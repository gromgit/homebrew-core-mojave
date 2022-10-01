class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.8.1.0/cabal-install-3.8.1.0.tar.gz"
  sha256 "61ce436f2e14e12bf07ea1c81402362f46275014cd841a76566f0766d0ea67e6"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.8"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cabal-install"
    sha256 cellar: :any_skip_relocation, mojave: "696645ded732343a76c978233c821f971be75817d9fb3e1a0d286c659818bbf8"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      end
      on_arm do
        # https://github.com/haskell/cabal/issues/7433#issuecomment-858590474
        url "https://downloads.haskell.org/~ghcup/unofficial-bindists/cabal/3.6.0.0/cabal-install-3.6.0.0-aarch64-darwin-big-sur.tar.xz"
        sha256 "7acf740946d996ede835edf68887e6b2f1e16d1b95e94054d266463f38d136d9"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz"
      sha256 "32d1f7cf1065c37cb0ef99a66adb405f409b9763f14c0926f5424ae408c738ac"
    end
  end

  def install
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
