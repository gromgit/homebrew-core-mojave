class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "b4eced76660e5e4bcdead3a3026608d500576fac574e49371cf9de8c98041b71"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghostunnel"
    sha256 cellar: :any_skip_relocation, mojave: "95c965b8208c8365c0303d3846fca264a8dc11500d71ecf4a94c7bfe8066f752"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
