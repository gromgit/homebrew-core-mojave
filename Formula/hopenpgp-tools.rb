class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.7/hopenpgp-tools-0.23.7.tar.gz"
  sha256 "b04137b315106f3f276509876acf396024fbb7152794e1e2a0ddd3afd740f857"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hopenpgp-tools"
    sha256 cellar: :any_skip_relocation, mojave: "45b7037eaa70fabe355cd56862b0b7348060c95e40ae4887b5c6b89b808a0216"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "zlib"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    # hOpenPGPTools's dependency hOpenPGP has conflict instance (Hashable Set) w/ hashable above 1.3.4.0
    # remove when hOpenPGP remove conflict instance or add upper bound of hashable
    # aeson has breaking change of 2.x.x.x
    # remove when hopenpgp-tools adopt aeson 2.x.x.x or add upper bound of aeson
    cabal_args = std_cabal_v2_args + ["--constraint=hashable<1.3.4.0", "--constraint=aeson<1.6"]
    system "cabal", "v2-update"
    system "cabal", "v2-install", *cabal_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
