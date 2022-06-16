class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "dc562cf774f88b12b6aeebdac5a00e62e8598b3f84da2130a54a67a60c5debf2"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brogue"
    sha256 mojave: "84749a3593f3ef05c2abfadb33a8f71e209fca53d3a9713ec4274ddb31ff6287"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  def install
    system "make", "bin/brogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}"
    libexec.install "bin/brogue", "bin/keymap.txt", "bin/assets"

    # Use var directory to save highscores and replay files across upgrades
    (bin/"brogue").write <<~EOS
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    EOS
  end

  def post_install
    (var/"brogue").mkpath
  end

  def caveats
    <<~EOS
      If you are upgrading from 1.7.2, you need to copy your highscores file:
          cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
    EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end
