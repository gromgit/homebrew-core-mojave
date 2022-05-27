class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 8

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgaiagraphics"
    rebuild 2
    sha256 cellar: :any, mojave: "6b46ec25fcda5f8864f27735fd65bed12899b7395a4f797b6fbac721b10f263d"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj@7"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
