class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.6/hopenpgp-tools-0.23.6.tar.gz"
  sha256 "3df2f26a8e1c2be92c54b1b347474464a23d213a7982dd4afb8c88c6b6325042"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hopenpgp-tools"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "becdb131b030a227b980232db796f7df77f3258f9517009d5ca987686eb125ae"
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
