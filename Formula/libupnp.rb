class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.13/libupnp-1.14.13.tar.bz2"
  sha256 "025d7aee1ac5ca8f0bd99cb58b83fcfca0efab0c5c9c1d48f72667fe40788a4e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libupnp"
    sha256 cellar: :any, mojave: "f113fb2cf104963ff808050cac477074d5c2924b05e56606a04e5d51823ce6b3"
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
