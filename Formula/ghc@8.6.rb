class GhcAT86 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-src.tar.xz"
  sha256 "4d4aa1e96f4001b934ac6193ab09af5d6172f41f5a5d39d8e43393b9aafee361"
  # We bundle a static GMP so GHC inherits GMP's license
  license all_of: [
    "BSD-3-Clause",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghc@8.6"
    rebuild 4
    sha256 mojave: "f990a61074c565b0f6f27b24d2110b72e09757c61984643c049c6c62813a8a4c"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-12-10", because: :unmaintained

  depends_on "python@3.10" => :build
  depends_on arch: :x86_64

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  resource "gmp" do
    on_macos do
      url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
      mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
      mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
      sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
    end
  end

  # https://www.haskell.org/ghc/download_ghc_8_6_5#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz"
      sha256 "dfc1bdb1d303a87a8552aa17f5b080e61351f2823c2b99071ec23d0837422169"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-fedora27-linux.tar.xz"
      sha256 "cf78b53eaf336083e7a05f4a3000afbae4abe5bbc77ef80cc40e09d04ac5b4a1"
    end
  end

  # Fix for Catalina compatibility https://gitlab.haskell.org/ghc/ghc/issues/17353
  patch :DATA

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.10")

    args = %w[--enable-numa=no]
    if OS.mac?
      # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
      # executables link to Homebrew's GMP.
      gmp = libexec/"integer-gmp"

      # GMP *does not* use PIC by default without shared libs so --with-pic
      # is mandatory or else you'll get "illegal text relocs" errors.
      resource("gmp").stage do
        system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                              "--build=#{Hardware.oldest_cpu}-apple-darwin#{OS.kernel_version.major}"
        system "make"
        system "make", "install"
      end

      args = ["--with-gmp-includes=#{gmp}/include",
              "--with-gmp-libraries=#{gmp}/lib"]
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      binary_args = args
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    # Disable PDF document generation (fails with newest sphinx)
    (buildpath/"mk/build.mk").write <<-EOS
      BUILD_SPHINX_PDF = NO
      libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-intree-gmp
    EOS

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
__END__
diff -pur a/rts/Linker.c b/rts/Linker.c
--- a/rts/Linker.c	2019-08-25 21:03:36.000000000 +0900
+++ b/rts/Linker.c	2019-11-05 11:09:06.000000000 +0900
@@ -192,7 +192,7 @@ int ocTryLoad( ObjectCode* oc );
  *
  * MAP_32BIT not available on OpenBSD/amd64
  */
-#if defined(x86_64_HOST_ARCH) && defined(MAP_32BIT)
+#if defined(x86_64_HOST_ARCH) && defined(MAP_32BIT) && !defined(__APPLE__)
 #define TRY_MAP_32BIT MAP_32BIT
 #else
 #define TRY_MAP_32BIT 0
@@ -214,7 +214,7 @@ int ocTryLoad( ObjectCode* oc );
  */
 #if !defined(ALWAYS_PIC) && defined(x86_64_HOST_ARCH)

-#if defined(MAP_32BIT)
+#if defined(MAP_32BIT) && !defined(__APPLE__)
 // Try to use MAP_32BIT
 #define MMAP_32BIT_BASE_DEFAULT 0
 #else
