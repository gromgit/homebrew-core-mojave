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
    sha256 cellar: :any, mojave: "d4a1519a693b9ef9c21b82f7fa83d95e6ab9a32095b8a5e6f147fbeed8365df4"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg@4"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Use python3 print()
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/master/debian/patches/0002-Use-python3-print.patch"
    sha256 "8cf333e691cf19494962b51748b8246502432867d9feb3d7919d329cb3696e97"
  end

  def install
    # Fix unrecognized "PRId64" format specifier
    inreplace "src/theorautils.c", "#include <limits.h>", "#include <limits.h>\n#include <inttypes.h>"

    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
      "APPEND_LINKFLAGS=-headerpad_max_install_names",
    ]
    system "scons", "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
