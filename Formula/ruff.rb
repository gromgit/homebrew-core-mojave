class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.141.tar.gz"
  sha256 "5238f4f27d03e7352a6322abc3e207ac41f2b591df3a3307993c1ab9d851c316"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ruff"
    sha256 cellar: :any_skip_relocation, mojave: "4739c2cd4fb7a985ebf17a687d1d34a0c903e7e9066524e1a46d81d6e83b1609"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS
    expected = <<~EOS
      test.py:1:1: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end
