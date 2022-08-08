class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "03a17397782f944ab8425e2ade224e90d181febc0202b8b80e791df62be7dbca"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ttdl"
    sha256 cellar: :any_skip_relocation, mojave: "e050d0730e146ceb387b86a00bf2b14fee19cdf2f86c3617a327301f976e2205"
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
