class GhcAT92 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/9.2.4/ghc-9.2.4-src.tar.xz"
  sha256 "15213888064a0ec4e7723d075f31b87a678ce0851773d58b44ef7aa3de996458"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(9\.2(?:\.\d+)+)\s*?</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "568c1506c287de74f57de9183979f101e2cdc8f6f1574a6ac57f0e3c48d30e6c"
    sha256 cellar: :any,                 arm64_monterey: "34c9d1168316a1e4cbc9f7c1ad578f5e4e445dbfa00ba91983291e0d722917e5"
    sha256 cellar: :any,                 arm64_big_sur:  "f98aba7d6315c5f22f27705ce3edbc4b2f8911d7f5e547988d03155cae0f3fc6"
    sha256                               ventura:        "23847ab2e954b54c43626b82aa584793f769e258d796bd1d728c423ad77ef6f7"
    sha256                               monterey:       "0537e93c72034f824885f632aa2f1e02f605a0d81839cdaddb29931437eab855"
    sha256                               big_sur:        "4dc1263be2893e27d196456c29f2c6469891f931cbc4b02786fdaf7dfaeecc59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6956c91e7df7acbc5af483c22d121b3b0392792e9e5210bf5af451c2ab05a7"
  end

  keg_only :versioned_formula

  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on macos: :catalina

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gmp" => :build
  end

  # GHC 9.2.4 user manual recommend use LLVM 9 through 12
  # https://downloads.haskell.org/~ghc/9.2.4/docs/html/users_guide/9.2.4-notes.html
  # and we met some unknown issue w/ LLVM 13 before https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  # so conservatively use LLVM 12 here
  on_arm do
    depends_on "llvm@12"
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-aarch64-apple-darwin.tar.xz"
        sha256 "b1fcab17fe48326d2ff302d70c12bc4cf4d570dfbbce68ab57c719cfec882b05"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-apple-darwin.tar.xz"
        sha256 "e1fe990eb987f5c4b03e0396f9c228a10da71769c8a2bc8fadbc1d3b10a0f53a"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-ubuntu20.04-linux.tar.xz"
      sha256 "a0ff9893618d597534682123360e7c80f97441f0e49f261828416110e8348ea0"
    end
  end

  # Backport fix for segfaults on macOS Ventura ARM
  # Ref: https://gitlab.haskell.org/ghc/ghc/-/commit/74ca6191fa0dbbe8cee3dc53741b8d59fbf16b09
  patch :DATA

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = which("python3.11")
    # Work around build failure: fatal error: 'ffitarget_arm64.h' file not found
    # Issue ref: https://gitlab.haskell.org/ghc/ghc/-/issues/20592
    # TODO: remove once bootstrap ghc is 9.2.3 or later.
    ENV.append_path "C_INCLUDE_PATH", "#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac? && Hardware::CPU.arm?

    resource("binary").stage do
      binary = buildpath/"binary"

      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp"
    system "make"
    ENV.deparallelize { system "make", "install" }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    (lib/"ghc-#{version}/package.conf.d/package.cache").unlink
    (lib/"ghc-#{version}/package.conf.d/package.cache.lock").unlink

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
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
diff --git a/includes/CodeGen.Platform.hs b/includes/CodeGen.Platform.hs
index 0dfac62a3f125d87fc68d990decfb83c0c511b62..ebec0212bd0f48071ae51673fdeb7b86c156936d 100644
--- a/includes/CodeGen.Platform.hs
+++ b/includes/CodeGen.Platform.hs
@@ -1028,6 +1028,14 @@ freeReg 29 = False
 -- ip0 -- used for spill offset computations
 freeReg 16 = False

+#if defined(darwin_HOST_OS) || defined(ios_HOST_OS)
+-- x18 is reserved by the platform on Darwin/iOS, and can not be used
+-- More about ARM64 ABI that Apple platforms support:
+-- https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms
+-- https://github.com/Siguza/ios-resources/blob/master/bits/arm64.md
+freeReg 18 = False
+#endif
+
 # if defined(REG_Base)
 freeReg REG_Base  = False
 # endif
