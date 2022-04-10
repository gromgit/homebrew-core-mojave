class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.3.0.tar.gz"
  sha256 "05e2cdcfd91e6abef91cb01ad3074583b8289f6e74054e070bfbf6a4e684865e"
  license "MIT"
  head "https://github.com/NerdyPepper/eva.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eva"
    sha256 cellar: :any_skip_relocation, mojave: "2f74dfc0445bc9079af0ef73ff21da3034d3ebb76464ca4ee8042fe25f7ac04f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "6.0", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end
