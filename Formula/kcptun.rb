class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/refs/tags/v20220628.tar.gz"
  sha256 "6a63facc902594b4ca5f0456e58196cf7b2a2451594fe2f69b55ac712ceb85e8"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kcptun"
    sha256 cellar: :any_skip_relocation, mojave: "9175671388190ffe28116f3cc888e289069846a0140be0d9b9f1bdf0b7d0681c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kcptun_server"), "./server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  service do
    run [opt_bin/"kcptun_client", "-c", etc/"kcptun_client.json"]
    keep_alive true
    log_path var/"log/kcptun.log"
    error_log_path var/"log/kcptun.log"
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
