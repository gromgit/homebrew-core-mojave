class Sqls < Formula
  desc "SQL language server written in Go"
  homepage "https://github.com/lighttiger2505/sqls"
  url "https://github.com/lighttiger2505/sqls/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0f417123331b23a50b10f2724befc53aa82f44150cf84f28bfb885f768697a01"
  license "MIT"
  head "https://github.com/lighttiger2505/sqls.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sqls"
    sha256 cellar: :any_skip_relocation, mojave: "2f5fd4e922e00d7a96507a54a89b9c4d763c2dbc657cc2c3833316ae57ff9ad9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId":88075,
          "rootPath":"#{testpath}",
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/sqls", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
