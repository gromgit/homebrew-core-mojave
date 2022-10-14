class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://programming.nu/"
  url "https://github.com/programming-nu/nu/archive/v2.3.0.tar.gz"
  sha256 "1a6839c1f45aff10797dd4ce5498edaf2f04c415b3c28cd06a7e0697d6133342"
  license "Apache-2.0"
  revision 1
  head "https://github.com/programming-nu/nu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nu"
    rebuild 1
    sha256 cellar: :any, mojave: "120f4007605aea6ddf0f48ae62ce7664ae7e8b91bd8b9b13d7a46867bb43be64"
  end

  depends_on "pcre"

  uses_from_macos "llvm" => :build
  uses_from_macos "swift" => :build # For libdispatch on Linux.
  uses_from_macos "libffi"

  on_linux do
    depends_on "gnustep-make" => :build
    depends_on "gnustep-base"
    depends_on "libobjc2"
    depends_on "readline"
  end

  on_arm do
    # objc/NuBridge.m:1242:6: error: implicit declaration of function 'ffi_prep_closure' is invalid in C99
    # Since libffi.tbd only exports '_ffi_prep_closure' on x86_64, we need to use formula until fixed.
    # Issue ref: https://github.com/programming-nu/nu/issues/97
    depends_on "libffi"
  end

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  # Fix Snow Leopard or Lion check to avoid `-arch x86_64` being added to ARM build
  # PR ref: https://github.com/programming-nu/nu/pull/101
  # TODO: Remove if upstream PR is merged and in a release.
  patch do
    url "https://github.com/programming-nu/nu/commit/0a837a407f9e9b8f7861b0dd2736f54c04729642.patch?full_index=1"
    sha256 "6c8567f0c2681f652dc087f6ef4b713bcc598e99729099a910984f9134f6a72c"
  end

  def install
    ENV.delete("SDKROOT") if MacOS.version < :sierra
    ENV["PREFIX"] = prefix
    # Don't hard code path to clang.
    inreplace "tools/nuke", "/usr/bin/clang", ENV.cc
    # Work around ARM build error where directives removed necessary code and broke mininush.
    # Nu uncaught exception: NuIvarAddedTooLate: explicit instance variables ...
    # Issue ref: https://github.com/programming-nu/nu/issues/102
    inreplace "objc/NuOperators.m", "#if defined(__x86_64__) || TARGET_OS_IPHONE",
                                    "#if defined(__x86_64__) || defined(__arm64__)"

    unless OS.mac?
      ENV.append_path "PATH", Formula["gnustep-make"].libexec

      # Help linker find libdispatch from swift on Linux.
      # This is only used for the mininush temporary compiler and is not needed for nush.
      ldflags = %W[
        "-L#{Formula["swift"].libexec}/lib/swift/linux"
        "-Wl,-rpath,#{Formula["swift"].libexec}/lib/swift/linux"
      ]
      ENV["LIBDIRS"] = ldflags.join(" ")

      # Remove CFLAGS that force using GNU runtime on Linux.
      # Remove this workaround when upstream drops these flags or provides a way to disable them.
      # Reported upstream here: https://github.com/programming-nu/nu/issues/99.
      inreplace "Nukefile", "-DGNU_RUNTIME=1", ""
      inreplace "Nukefile", "-fgnu-runtime", ""
    end

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!("\#{@destdir}/Library/Frameworks", "\#{@prefix}/Frameworks")
      s.sub!(/^;; source files$/, <<~EOS)
        ;; source files
        (set @framework_install_path "#{frameworks}")
      EOS
    end

    # Remove bundled libffi
    (buildpath/"libffi").rmtree

    # Remove unused prefix from ffi.h to match directory structure of libffi formula
    include_path = (OS.mac? && Hardware::CPU.arm?) ? "ffi" : "x86_64-linux-gnu"
    inreplace ["objc/NuBridge.h", "objc/NuBridge.m", "objc/Nu.m"], "<#{include_path}/", "<"

    system "make", "CC=#{ENV.cc}"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        Nu.framework was installed to:
          #{frameworks}/Nu.framework

        You may want to symlink this Framework to a standard macOS location,
        such as:
          ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
      EOS
    end
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
