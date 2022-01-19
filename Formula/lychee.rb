class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.2.tar.gz"
  sha256 "55b83a5d7145afc4358b29db49d8e107494b64bf4f8938da865ffed978d29cda"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lychee"
    sha256 cellar: :any, mojave: "67fbb8462c266c7b813a1f5855c41608cb600e6e83fae12d250e106978f2f5df"
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
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end
