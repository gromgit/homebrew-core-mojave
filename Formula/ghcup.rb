class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.18.0/ghcup-hs-v0.1.18.0.tar.bz2"
  sha256 "fac7e5fd0ec6d95c3d2daa56b4d77ec8daa37b179b43e62c528d90053b01aeb9"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghcup"
    sha256 cellar: :any_skip_relocation, mojave: "7fe16d2e83d6c5fffbdbf55a3032259de3a5bcd51c0f9c9af19e4e9eac52e2bf"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # upstream mr: https://gitlab.haskell.org/haskell/ghcup-hs/-/merge_requests/277
  patch do
    url "https://gitlab.haskell.org/fishtreesugar/ghcup-hs/-/commit/22f0081303b14ea1da10e6ec5020a41dab591668.diff"
    sha256 "ae513910d39f5d6b3d00de5d5f4da1420263c581168dabd221f2fe4f941c7c65"
  end

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
