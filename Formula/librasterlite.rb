class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 8

  livecheck do
    skip "No longer developed"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librasterlite"
    rebuild 1
    sha256 cellar: :any, mojave: "4b2882718d1c67589617048c3c1d9552621eba87d9133523cbdf434467793e13"
  end

  deprecate! date: "2022-03-05", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libspatialite"
  depends_on "proj@7"
  depends_on "sqlite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
