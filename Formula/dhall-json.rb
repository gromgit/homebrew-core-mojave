class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.9/dhall-json-1.7.9.tar.gz"
  sha256 "f6b9f4f6046648d2c51c6a7d11b5c08b0935d820cc5dfb67aaec5363b7213487"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall-json"
    sha256 cellar: :any_skip_relocation, mojave: "0d8ea39839bc437b29b4c080f2c4438706ace028080c97a18149980455db90e0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
