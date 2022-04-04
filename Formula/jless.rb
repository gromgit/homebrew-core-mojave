class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3f1168c9b2432f7f4fa9dd3c31b55e371ef9d6f822dc98a8cdce5318a112bf2d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jless"
    sha256 cellar: :any_skip_relocation, mojave: "9460089037a7ba17bf1d1b5495c2c37a095f1a8e111f51a59e35455a585e4e1e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write('{"hello": "world"}')
    res, process = Open3.capture2("#{bin}/jless example.json")
    assert_equal("world", JSON.parse(res)["hello"])
    assert_equal(process.exitstatus, 0)
  end
end
