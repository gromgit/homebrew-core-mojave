class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.2.1.tar.gz"
  sha256 "50fa29dec01fb4cc5e6365c93fea5e7747506c1fb307233e5f0a82958a50d206"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nickel"
    sha256 cellar: :any_skip_relocation, mojave: "2062788407f8a038d21ba128ef83d78415c26cdd5686099e32ca9b76683a31cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
