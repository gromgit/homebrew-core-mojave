class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.4.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.4.tar.gz"
  sha256 "b1e2120e4ae07df952c4a858731619733115c5f438965de4fab41d6bf7e7a508"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/neon"
    sha256 cellar: :any, mojave: "2af9ff24f2cebd5be1ff826137d6af6a0d926854cf2c1e82caea283b881a3577"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }

 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
