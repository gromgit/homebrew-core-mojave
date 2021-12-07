class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.9/dhall-yaml-1.2.9.tar.gz"
  sha256 "8637b4e78b60a9318d17ffe99a45a9931886e0a4f5e99922d2b246187196c93e"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall-yaml"
    sha256 cellar: :any_skip_relocation, mojave: "1ddfd76d6647b320bfc2215e113982b376e70b10abbd20a3f403d47917eb2e5e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
