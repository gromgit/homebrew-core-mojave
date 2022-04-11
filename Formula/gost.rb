class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.2.tar.gz"
  sha256 "143174a9ba5b0b6251d1d9a52267220f97bec1319676618746c1a5d7a7a86d96"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gost"
    sha256 cellar: :any_skip_relocation, mojave: "b97dd37c4b981ef2f836a1e98fe693b77b9d966cc69ab2de24c9d9ef4f2a7afa"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
