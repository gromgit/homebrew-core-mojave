class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "763d5a5c9219f2084d5ec6273911f84213e5424f127117ab0f1c611609663a8b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpg-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a6259bb236e6a6d235f944d47add3197bb52d1a403e877632065a66efab42eca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end
