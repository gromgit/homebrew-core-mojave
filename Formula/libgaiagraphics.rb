class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 9

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgaiagraphics"
    sha256 cellar: :any, mojave: "9727e9cff4bd4ff875cff1adcc6cf8d0c6f7b3e670defa44417a511a6b4f4b8b"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg-turbo"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj@7"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
