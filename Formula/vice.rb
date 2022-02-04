class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.6.1.tar.gz"
  sha256 "20df84c851aaf2f5000510927f6d31b32f269916d351465c366dc0afc9dc150c"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vice"
    sha256 mojave: "fa59670a4bdcc970a4f4a37d19e046f0467911513fe52b14420b393a9ee6f89e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"

  def install
    configure_flags = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-arch
      --disable-pdf-docs
      --enable-native-gtk3ui
      --enable-midi
      --enable-lame
      --enable-external-ffmpeg
      --enable-ethernet
      --enable-cpuhistory
      --with-flac
      --with-vorbis
      --with-gif
      --with-jpeg
      --with-png
    ]

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  test do
    assert_match "Initializing.", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
