class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "48554e1b030781c49c98c5882369a92e475d76fee0d5ce2d2f79966826447086"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/treefmt"
    sha256 cellar: :any_skip_relocation, mojave: "bc4558e1517cd3c666f408a2165f3df06f4ee77991909a47fa5ae7e9714c74b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that treefmt responds as expected when run without treefmt.toml config
    assert_match "treefmt.toml could not be found", shell_output("#{bin}/treefmt 2>&1", 1)
  end
end
