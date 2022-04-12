class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.40/dhall-bash-1.0.40.tar.gz"
  sha256 "a9d1feba3c9ceeecdd24fb4a4d8f6450a50ca31ede30aa4d7a8e9d8489cc7f3a"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall-bash"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5ed5c9e0c774c8c5f592d4842f370c0350ffe345dced4ed7d6e009bce0ce2f25"
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
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
