class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.6.0.tar.gz"
  sha256 "34537fd7b8b5fdc79a35284236443b07c54dded81d558c5bb774a2a354b498c7"
  license "MIT"
  head "https://github.com/antifuchs/chars.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chars"
    sha256 cellar: :any_skip_relocation, mojave: "ec0dcec32cd96ca26d23a6954d9af9bbb85873b63c7747e2578b82b4c0d50a93"
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
