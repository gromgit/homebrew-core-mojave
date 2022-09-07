class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c20608c20233aa4495eabed631e70448e307e8ab0b006f328d6e72d3278311b5"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ttdl"
    sha256 cellar: :any_skip_relocation, mojave: "c6cb60aa369b8e0280a1f36d5bbd57ca8c487cd1c2e75f1191ff4723c5dea01c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
