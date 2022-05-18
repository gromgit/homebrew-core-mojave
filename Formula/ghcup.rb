class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.8/ghcup-hs-v0.1.17.8.tar.bz2"
  sha256 "789cd286b6a7f2bf43f84079888dd3771a9944cca72ca4bfc971689936d0ae36"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghcup"
    sha256 cellar: :any_skip_relocation, mojave: "d142b179fc77416122a7e6989a855bca92c3cdc6dda0718600591567451b6daf"
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
