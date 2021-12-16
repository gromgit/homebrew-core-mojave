class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.47/fs-uae-3.1.47.tar.xz"
  sha256 "b9761b7f60068c8b7d4daa0f08efdfbaa0662901ac1aba9101964906bc558320"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fs-uae"
    rebuild 2
    sha256 cellar: :any, mojave: "a21aa49ba8a43ddd50433e321a2f62c39d6e785741921e91cfc7fa9dfcd984cc"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
