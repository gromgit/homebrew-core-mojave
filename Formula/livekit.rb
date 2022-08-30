class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4f25983914a2611ad7f534f0d76204c0f39c81b670272903ca10f2119f4ea257"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/livekit"
    sha256 cellar: :any_skip_relocation, mojave: "fb096e124ef9e575ea3bb52ad4d3862595faccbc2bd7c4adaa1da4886925ad52"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
