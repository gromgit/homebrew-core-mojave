class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.106.1.tar.gz"
  sha256 "23220289e80920650d463413ede616b1b51b8a007301b344f76163b5b27fb0fd"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghz-web"
    sha256 cellar: :any_skip_relocation, mojave: "fbef825c499e3c99a499fff48626897af2e4279900c212406b96f97390460e9b"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
