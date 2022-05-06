class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spatialite-tools"
    sha256 cellar: :any, mojave: "975d173f31b4e4009a0ddaa0bc8a16e61b73d75d9205efd12b3ec31d174c02b3"
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
