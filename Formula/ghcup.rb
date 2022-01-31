class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.4/ghcup-hs-v0.1.17.4.tar.bz2"
  sha256 "9973a42397bcdecfaf5f5d8251b4513422b80e901b2f2e77b80b0ad28d19f406"
  license "LGPL-3.0-only"
  revision 1
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghcup"
    sha256 cellar: :any_skip_relocation, mojave: "cfbd4e0cc425189757f8792fc9ab6c26a86fdd7db25eeec9588040bed9977e4e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Disable self-upgrade functionality. Backported from:
  # https://gitlab.haskell.org/haskell/ghcup-hs/-/commit/b245c11b1d77236c75c29fb094bbb9cfd70eed48
  # Remove at next release.
  patch do
    url "https://gitlab.haskell.org/haskell/ghcup-hs/-/snippets/3838/raw/main/0001-Allow-to-disable-self-upgrade-functionality-wrt-305.patch"
    sha256 "a20152dead868cf1f35f9c0a3cb2fca30bb4ef09c4543764c1f1dc71a8ba47f7"
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
