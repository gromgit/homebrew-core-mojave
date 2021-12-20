class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.62/fs-uae-3.1.62.tar.xz"
  sha256 "57581355fe5cb9a01c2cd2289c1dce50e42694d7105454fd9d75206fdf91c467"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fs-uae"
    sha256 cellar: :any, mojave: "b420a02a5c6ba6f6de2f64f68a5f69fd09c7ef1cf828e92f7357479e24791a80"
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
