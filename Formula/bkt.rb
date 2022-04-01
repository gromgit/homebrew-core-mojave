class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.3.tar.gz"
  sha256 "38c418e8abe1bf6835f1b16d02c03677075af6b10ad4723392540ec79797520e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bkt"
    sha256 cellar: :any_skip_relocation, mojave: "d6ff84b22918c4c755f915f83d7b239bf11fe68f2c3f4f761aa281ac8209b52a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
