class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.1.tar.gz"
  sha256 "1ebc71f8741d644cdc1fd3f5c2f78f0991bc56e038c1132cbe8c9eee144c8f03"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lychee"
    sha256 cellar: :any, mojave: "d6dc1f7148379c64f54884236d1d83fec1daddce57a87ef1e4d47f0db5a8ec47"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
