class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "eeb96b6eb23d61b7eba004c4ede8b3238afa4798cb0788af5511d12409bc971a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lighthouse"
    sha256 cellar: :any_skip_relocation, mojave: "371f1152e83937ea0a2b3f05487998ef49cb2f8f3fc4d4f3006031780bddcf04"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
