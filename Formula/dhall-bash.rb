class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.39/dhall-bash-1.0.39.tar.gz"
  sha256 "68ce22ada11dcd7d92268b79363bd51c835aecd1f44e8b93ce1e448d5be1c02f"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall-bash"
    sha256 cellar: :any_skip_relocation, mojave: "39ec55ee826e40a304c16f21763a2b94a05e411a85d61a6ef6ecca6e4349f44a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
