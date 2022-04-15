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
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "37919732bfaa0271150c576c08d39bf592b757517f626dde27ac45789292e7bb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
