class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.2.7.tar.gz"
  sha256 "72b2e47e987102d67c9dcbb60e26c4ff0b20e6f844d0d2b9d91c3f073374aee0"
  license "MIT"
  head "https://github.com/NerdyPepper/eva.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eva"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "69b0058a1381ae49d58e3b8ed547c21f2f89204c4e835d411704dc06c9f8923b"
  end


  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "6.0", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end
