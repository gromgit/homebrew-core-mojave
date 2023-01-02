class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.5/diff-pdf-0.5.tar.gz"
  sha256 "e7b8414ed68c838ddf6269d11abccdb1085d73aa08299c287a374d93041f172e"
  license "GPL-2.0-only"
  revision 5

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/diff-pdf"
    rebuild 1
    sha256 cellar: :any, mojave: "439d504a3b8d6ae21cb70cfa37d90479ef9141ad04bc8bce4d3f8466c026cdc5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxwidgets"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert (testpath/"no_diff.pdf").file?
  end
end
