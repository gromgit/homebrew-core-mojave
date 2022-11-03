class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.78/pstoedit-3.78.tar.gz"
  sha256 "8cc28e34bc7f88d913780f8074e813dd5aaa0ac2056a6b36d4bf004a0e90d801"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pstoedit"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "abedb12300897ed38a47e2438da3f08f4b49c149b197090adc7bd8451cf55ac9"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  # "You need a C++ compiler, e.g., g++ (newer than 6.0) to compile pstoedit."
  fails_with gcc: "5"

  def install
    ENV.cxx11 if OS.mac?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
