class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mjpegtools"
    sha256 cellar: :any, mojave: "0b00e6ff8fe6d9c1908b51d38da3cca2d2522e9b48e39c316c33a2fe6dc8d31b"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--enable-simd-accel"
    system "make", "install"
  end
end
