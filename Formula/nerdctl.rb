class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "3bc0ea455b7f609525b4f6f43c50f5cf0ffc8909845d91892a9ed1ab7b201a1e"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "424b79bcc70aece2d26c20cc609641cb314edd6a29006958fff19a19be7286e3"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/nerdctl"

    generate_completions_from_executable(bin/"nerdctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
