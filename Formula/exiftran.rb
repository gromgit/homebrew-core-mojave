class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://www.kraxel.org/releases/fbida/"
    regex(/href=.*?fbida[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exiftran"
    sha256 cellar: :any, mojave: "6ee5bb33eec33f9f53db3889d5b52dc4efda72aa75c133d20e737c3a08d6a997"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "pixman"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "ghostscript"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "openmotif"
    depends_on "poppler"
    depends_on "webp"
  end

  # Fix build on Darwin
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/185c281/exiftran/fix-build.diff"
    sha256 "017268a3195fb52df08ed75827fa40e8179aff0d9e54c926b0ace5f8e60702bf"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "RESDIR=#{share}", "install"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end
