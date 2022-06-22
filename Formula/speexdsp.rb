class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2.1.tar.gz"
  sha256 "d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/speexdsp"
    sha256 cellar: :any, mojave: "cd70818baa2d3562d456ed5c069763602a84e45ff14302149159457fae07b5ab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
