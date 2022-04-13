class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.0.tar.gz"
  sha256 "ffcbd5851d98586c7e1caf43bad66164211a3b61d12bf860a0598448ff9f2b38"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lasso"
    rebuild 1
    sha256 cellar: :any, mojave: "0c6c6172b6a7be5021742a80c4a07815a3b5e5d463e2535ea0f6ab7b6d3551f5"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "six" => :build
  depends_on "glib"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    libxml = OS.mac? ? MacOS.sdk_path/"usr/include/libxml2" : Formula["libxml2"].include/"libxml2"
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{libxml}",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
