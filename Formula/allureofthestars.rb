class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/allureofthestars"
    sha256 mojave: "0aab87cc28db42afc56aa1b4a0afa683a055c6f847e12f4aa57c39380410cc0c"
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
