class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "53a9be30f59d6d115dd2d5ad49145c103f93daee4a85f0d49ba060ad2c7adbd2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lighthouse"
    sha256 cellar: :any_skip_relocation, mojave: "0225d988542aa1f6dc6ccfc969f77127dcd39a4f18409636ae875f8383d9ba53"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
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
