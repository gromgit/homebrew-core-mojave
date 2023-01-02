class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"
  license "GPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dosbox"
    sha256 cellar: :any, mojave: "0da62201ce409585711054e086529ce0fd0f291d63ec47d2c3397499d5a82998"
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl12-compat"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
