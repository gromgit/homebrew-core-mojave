class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.3.1.tar.gz"
  sha256 "d6a6eb8e0d46de1fea9bd00c361bd7955fcd7cc8f3310b786aad48c1dce7b3f7"
  license "MIT"
  head "https://github.com/NerdyPepper/eva.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eva"
    sha256 cellar: :any_skip_relocation, mojave: "f057aa837c4f66c29411de622fb9fa5750cf184197a9044a192fb0960f7e5e80"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "6.0000000000", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end
