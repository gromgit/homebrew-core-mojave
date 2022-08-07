class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.2.0.tar.gz"
  sha256 "7d89803cb5ac235274461b44ebe665ab4a9dacc3e47aca29ed5be55765c9e6f2"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nickel"
    sha256 cellar: :any_skip_relocation, mojave: "0fcbfe6d1d19b3348f54b3409ff94d29d06c002dfdcbd26161c7136e4cd6e10d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
