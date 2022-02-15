class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://pauljuliusmartinez.github.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "8b36d117ac0ef52fa0261e06b88b5ae77c2ff4beeb54f2c906a57f066dc46179"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jless"
    sha256 cellar: :any_skip_relocation, mojave: "7c2837eaced017cb96a1be19b4b429256186a16b2b8e83fc4305124052376829"
  end

  depends_on "rust" => :build

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
