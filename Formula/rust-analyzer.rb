class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-17",
       revision: "e6e72809e3b55da3a57af95e6445a12729331ad6"
  version "2022-01-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rust-analyzer"
    sha256 cellar: :any_skip_relocation, mojave: "3e98e15a23aecb6cbe62442a3cf4b6ae22d9d852d459414663f61a0020f98ebb"
  end

  depends_on "rust" => :build

  # Fix build using rust 1.57. Remove with next release.
  patch do
    url "https://github.com/rust-analyzer/rust-analyzer/commit/df5340386365b2b16c4e9bbae546504b97564c41.patch?full_index=1"
    sha256 "296078507fd4a3b86d8bc2ea2acc8ae87ac908430eedd773730924d53cd3dd45"
  end

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
