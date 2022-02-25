class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "5d776cb6488743ccdaeeffb4bfc54d84862028170cee852a8bb5c156526ed263"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jless"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c818e8d965f9c6c0335633103dc7437100fe24e19dee6de4ba7230d26fe7fa59"
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
