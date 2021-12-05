class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.3.0/Allure-0.10.3.0.tar.gz"
  sha256 "0ae3ffbdf8bff2647ed95c2b68073874829b26d7e33231a284a2720cf3414fdc"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/allureofthestars"
    rebuild 2
    sha256 mojave: "b8fdb9780873ef82b35df96affa9e5679f6ac80399ce2703d0c8affc7f860a6a"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on "sdl2_ttf"

  def install
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_equal "",
      shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 --maxFps 100000 " \
                   "--stopAfterFrames 50 --automateAll --keepAutomated --gameMode battle " \
                   "--setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_equal "", (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
