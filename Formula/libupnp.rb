class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.14/libupnp-1.14.14.tar.bz2"
  sha256 "3ae23a2f2dbe3c4fe845a14d114d092743dac1184d024a8e900c2d3e78362150"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libupnp"
    sha256 cellar: :any, mojave: "1eafaa8f5749e534f21e564355abf74b02bcd3e3b7b76be31189950bfafbfc00"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
