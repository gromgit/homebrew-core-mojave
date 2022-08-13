class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "https://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"
  license "MIT"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/little-cms"
    sha256 cellar: :any, mojave: "06d0c3abd43756ed3e8bbe515f01773bc355860575b31dd5ecdf701bc69521bf"
  end

  deprecate! date: "2022-06-12", because: :unmaintained

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
