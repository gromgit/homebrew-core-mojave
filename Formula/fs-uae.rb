class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.66/fs-uae-3.1.66.tar.xz"
  sha256 "606e1868b500413d69bd33bb469f8fd08d6c08988801f17b7dd022f3fbe23832"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fs-uae"
    rebuild 1
    sha256 cellar: :any, mojave: "d29ab3504952e05b8e05b48b742170407bcab4bffc7f73b1dbffd96fedfb6cd2"
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

  uses_from_macos "zip"

  on_linux do
    depends_on "openal-soft"
  end

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
