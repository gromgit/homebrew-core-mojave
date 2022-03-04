class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.41.1/dhall-1.41.1.tar.gz"
  sha256 "9bea36ab0e1c965aef7474fabea67c3cfa3ca272007508ecd7bf22eaaae8d425"
  license "BSD-3-Clause"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall"
    sha256 cellar: :any_skip_relocation, mojave: "1f51fe912d3474f1611f7384ff837af53f1b93be524e2377b59c4869e6b9ff97"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/dhall.1"
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
