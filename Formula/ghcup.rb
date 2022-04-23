class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.7/ghcup-hs-v0.1.17.7.tar.bz2"
  sha256 "7620a913322563ab164b726bc06e01be7b4906e743149ad8c5504d1a663d7e4f"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghcup"
    sha256 cellar: :any_skip_relocation, mojave: "7c14ffffdfa89b7dd7a20fb3832544ad227fd8339a860f8e7ea95347557e46ec"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
  end
end
