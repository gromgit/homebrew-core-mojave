class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/v1.0.3.tar.gz"
  sha256 "6801559b6f8e17240ed8eef17a36eea8643412b5a7476980fd4e24b02a021b82"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/microsocks"
    sha256 cellar: :any_skip_relocation, mojave: "35401080d5d1bbdc3f016647cf4df23f3bb1e27448405b6696d05b79679dd60c"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    port = free_port
    fork do
      exec bin/"microsocks", "-p", port.to_s
    end
    sleep 2
    assert_match "The Missing Package Manager for macOS (or Linux)",
      shell_output("curl --socks5 0.0.0.0:#{port} https://brew.sh")
  end
end
