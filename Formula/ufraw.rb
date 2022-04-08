class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "https://ufraw.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"
  revision 4

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ufraw"
    sha256 mojave: "407d5454deb3113aa099cc5578bc3d4fdeb312d387b98def78e6134a2146e731"
  end

  depends_on "pkg-config" => :build
  depends_on "dcraw"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b8ed064e0d2567a4ced511755ba0a8cc5ecc75f7/ufraw/jpeg9.patch"
    sha256 "45de293a9b132eb675302ba8870f5b6216c51da8247cd096b24a5ab60ffbd7f9"
  end

  # Fix compilation with Xcode 9 and later,
  # see https://sourceforge.net/p/ufraw/bugs/419/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d5bf686c740d9ee0fdf0384ef8dfb293c5483dd2/ufraw/high_sierra.patch"
    sha256 "60c67978cc84b5a118855bcaa552d5c5c3772b407046f1b9db9b74076a938f6e"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share/"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end
