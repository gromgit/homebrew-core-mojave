class GccAT10 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-10.3.0/gcc-10.3.0.tar.xz"
  sha256 "64f404c1a650f27fc33da242e1f2df54952e3963a49e06e73f6940f3223ac344"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    url :stable
    regex(%r{href=.*?gcc[._-]v?(10(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256 big_sur:      "a2d5df73c659132ff4e393696a30076def85936855461701956aac62bf1a4c4f"
    sha256 catalina:     "42679d2d37117fd2c0243b61f1ee36d470fd293737f5f58a7b25ac816f733793"
    sha256 mojave:       "83af850b34188c1706d690153de1653f5289db2f6be04e1a1349d15ace86e1d9"
    sha256 x86_64_linux: "d7dc879970a5e5049b9570300fa3ab0fc13efb9f04c418fe9d6975ca1eaf63a5"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on arch: :x86_64
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def version_suffix
    version.major.to_s
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --disable-nls
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
    ]

    if OS.mac?
      args << "--build=x86_64-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
      end

      # Ensure correct install names when linking against libgcc_s;
      # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
      inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}"

      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # http://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
    end

    mkdir "build" do
      system "../configure", *args

      if OS.mac?
        # Use -headerpad_max_install_names in the build,
        # otherwise updated load commands won't fit in the Mach-O header.
        # This is needed because `gcc` avoids the superenv shim.
        system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
        system "make", "install"
      else
        system "make"
        system "make", "install-strip"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      gcc = bin/"gcc-#{version_suffix}"
      libgcc = Pathname.new(Utils.safe_popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink crt1.o and friends where gcc can find it.
      crtdir = if glibc_installed
        glibc.opt_lib
      else
        Pathname.new(Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=crti.o")).parent
      end
      ln_sf Dir[crtdir/"*crt?.o"], libgcc

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      specs = libgcc/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      system_header_dirs = ["#{HOMEBREW_PREFIX}/include"]

      if glibc_installed
        # https://github.com/Linuxbrew/brew/issues/724
        system_header_dirs << glibc.opt_include
      else
        # Locate the native system header dirs if user uses system glibc
        target = Utils.safe_popen_read(gcc, "-print-multiarch").chomp
        raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

        system_header_dirs += ["/usr/include/#{target}", "/usr/include"]
      end

      # Save a backup of the default specs file
      specs_string = Utils.safe_popen_read(gcc, "-dumpspecs")
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?

      specs_orig.write specs_string

      # Set the library search path
      # For include path:
      #   * `-isysroot #{HOMEBREW_PREFIX}/nonexistent` prevents gcc searching built-in
      #     system header files.
      #   * `-idirafter <dir>` instructs gcc to search system header
      #     files after gcc internal header files.
      # For libraries:
      #   * `-nostdlib -L#{libgcc}` instructs gcc to use brewed glibc
      #     if applied.
      #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
      #     libraries. It is essential if there are multiple brewed gcc
      #     with different versions installed.
      #     Noted that it should only be passed for the `gcc@*` formulae.
      #   * `-L#{HOMEBREW_PREFIX}/lib` instructs gcc to find the rest
      #     brew libraries.
      libdir = HOMEBREW_PREFIX/"lib/gcc/#{version_suffix}"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{HOMEBREW_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc}" : "+"} -L#{libdir} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{libdir} -rpath #{HOMEBREW_PREFIX}/lib

      EOS
    end
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc-#{version.major}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      struct exception { };
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        try { throw exception{}; }
          catch (exception) { }
          catch (...) { }
        return 0;
      }
    EOS
    system "#{bin}/g++-#{version.major}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    (testpath/"test.f90").write <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    EOS
    system "#{bin}/gfortran-#{version.major}", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`
  end
end
