class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "https://www.mcternan.me.uk/mscgen/"
  url "https://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?mscgen-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mscgen"
    sha256 cellar: :any, mojave: "f515ad9a82f5ba8b4b240cada38a494880070bd146c83658caba57b0c6b78130"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"

  def install
    system "./configure", *std_configure_args, "--with-freetype"
    system "make", "install"
  end
end
