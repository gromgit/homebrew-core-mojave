class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "23aabf22cced96ea25a28e1a1817bd62502d28140c3a9cf046d951accef5125c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fclones"
    sha256 cellar: :any_skip_relocation, mojave: "592833fc405d09a823514c6af9c651a5bbd1149e535a3629b2261b78b49556cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "a9707ebb28a5cf556818ea23a0c7282c", output
    assert_match "16aa71f09f39417ecbc83ea81c90c4e7", output
  end
end
