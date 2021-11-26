class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.18.2",
      revision: "8c6e4d389146413d327d69ff2fb54e7798d24503"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fortio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8d7b32e3d5e2251920698f2316c5e9a7de8f7d53f4077baa9df49f61f28d8ae7"
  end

  depends_on "go" => :build

  def install
    system "make", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
