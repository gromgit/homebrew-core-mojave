class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.8.0.tar.gz"
  sha256 "65339ee1d52dede5e862b30582b2adf8aff2113cd6b5ece91775e1510b24ffb9"
  license "MIT"
  head "https://github.com/rwos/gti.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gti"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "286d5c3451034be587c79ca0418b521e88d2a01ee264a0a18e523dd8f6d1a25d"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
