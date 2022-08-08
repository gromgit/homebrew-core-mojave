class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  license "ISC"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tiff2png"
    sha256 cellar: :any, mojave: "7317749f56d5537360e073cebb95b936112932a81c66cbebc672b24a42edc85b"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system "#{bin}/tiff2png", test_fixtures("test.tiff")
  end
end
