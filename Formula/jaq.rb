class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8ddf812157c4d0e999b2fadc25b9c13665528df08086114d575eee265973b81a"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jaq"
    sha256 cellar: :any_skip_relocation, mojave: "5cf975a5ad668308b5ade9337e1ae26df3c627b90249348c4ecc29b1181257c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
