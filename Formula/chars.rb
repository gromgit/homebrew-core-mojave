class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.6.0.tar.gz"
  sha256 "34537fd7b8b5fdc79a35284236443b07c54dded81d558c5bb774a2a354b498c7"
  license "MIT"
  head "https://github.com/antifuchs/chars.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chars"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "68509216b2beaf5d8277a065047f3a973ded9bb864e1cf58d6cc9ece9dd46402"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "Control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end
