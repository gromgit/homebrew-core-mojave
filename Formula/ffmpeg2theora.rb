class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 10
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git", branch: "master"

  livecheck do
    url "http://v2v.cc/~j/ffmpeg2theora/download.html"
    regex(/href=.*?ffmpeg2theora[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ffmpeg2theora"
    rebuild 1
    sha256 cellar: :any, mojave: "7f00820b013e6917ad07a649db6fc312a9824c8bb358b66ed3a8fe9aa032090c"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg@4"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Use python3 print()
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/master/debian/patches/0002-Use-python3-print.patch"
    sha256 "8cf333e691cf19494962b51748b8246502432867d9feb3d7919d329cb3696e97"
  end

  # Fix missing linker flags
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/debian/0.30-2/debian/patches/link-libm.patch"
    sha256 "1cf00c93617ecc4833e9d2267d68b70eeb6aa6183f0c939f7caf0af5ce8460b5"
  end

  def install
    # Fix unrecognized "PRId64" format specifier
    inreplace "src/theorautils.c", "#include <limits.h>", "#include <limits.h>\n#include <inttypes.h>"

    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
    ]
    args << "APPEND_LINKFLAGS=-headerpad_max_install_names" if OS.mac?
    system "scons", "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
