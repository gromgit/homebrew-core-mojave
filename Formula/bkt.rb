class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.4.tar.gz"
  sha256 "172c413709dc81ced9dfa2750aaa398864e904d1ed213bd19e51d45d1ff0a8ff"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bkt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "74220f66bb8ca4ab03e27bb000b3fc9cd3a1ad2c380238eb254976b2ff28d239"
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
