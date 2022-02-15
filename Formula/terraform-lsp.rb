class TerraformLsp < Formula
  desc "Language Server Protocol for Terraform"
  homepage "https://github.com/juliosueiras/terraform-lsp"
  url "https://github.com/juliosueiras/terraform-lsp.git",
      tag:      "v0.0.12",
      revision: "b0a5e4c435a054577e4c01489c1eef7216de4e45"
  license "MIT"
  head "https://github.com/juliosueiras/terraform-lsp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terraform-lsp"
    sha256 cellar: :any_skip_relocation, mojave: "a9a99109dd192a578387882f8cf9e5902d9f4bd8a3d8a7a77cabe0df746a4d31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.GitCommit=#{Utils.git_head}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-lsp serve -tcp -port #{port}"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length:", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/terraform-lsp serve -version")
  end
end
