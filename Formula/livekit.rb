class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "68163a751eb1eccee1233bfba8d3fcf8508b2695b47bd20373aa6ccebbfe369d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/livekit"
    sha256 cellar: :any_skip_relocation, mojave: "3f728335d8ed46f56af4eda54dd4283732545ba622baaa8d3413e8ab2994cc94"
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
