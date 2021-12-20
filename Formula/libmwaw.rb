class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.21/libmwaw-0.3.21.tar.xz"
  sha256 "e8750123a78d61b943cef78b7736c8a7f20bb0a649aa112402124fba794fc21c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmwaw"
    sha256 cellar: :any, mojave: "27241257136a23f8805abfc7364a8971dc48f54e506b8c49af8414a1b83020cc"
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "homebrew-test_document" do
    url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
    sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
