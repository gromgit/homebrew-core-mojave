class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "f59baaa629152ce9dcbb3a4e2ca72ce1275f43b1c24cee7d54b53c58534fa30f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nats-streaming-server"
    sha256 cellar: :any_skip_relocation, mojave: "e0160818ff5ba47a59f21a7c57258d1abe87e2809f821e0fef11b666e8fcc969"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    pid = fork do
      exec "#{bin}/nats-streaming-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
