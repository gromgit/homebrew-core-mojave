class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "763d5a5c9219f2084d5ec6273911f84213e5424f127117ab0f1c611609663a8b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpg-cli"
    sha256 cellar: :any_skip_relocation, mojave: "2a2b09b93db324bdcdd8d162402604de6996d7ab076f9b9a3fc3c84c6f94c498"
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
