class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.15/libupnp-1.14.15.tar.bz2"
  sha256 "794e92c6ea83456f25a929e2e1faa005f7178db8bc4b0b4b19eaca2cc7e66384"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libupnp"
    sha256 cellar: :any, mojave: "4431f3f8897a6808858b2d2e88302aa0b8f0ca837a28954523e9518fefd12b9f"
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
