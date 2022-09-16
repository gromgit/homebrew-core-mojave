class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.110.0.tar.gz"
  sha256 "254463fd61b316f709a84b184da5309be1c0a4a442145665da26d9ad98da1351"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghz-web"
    sha256 cellar: :any_skip_relocation, mojave: "794c39e93472e42f8ea0a1aa791fea2682fc5e692d83b400fa878834687b97ca"
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
