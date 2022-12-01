class Llama < Formula
  desc "Terminal file manager"
  homepage "https://github.com/antonmedv/llama"
  url "https://github.com/antonmedv/llama/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cf6fe219f2554c90aadbe4d0ebb961b53fe3296873addab1a3af941646e19ca2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/llama"
    sha256 cellar: :any_skip_relocation, mojave: "476a5b2efc5ee3c684a7d773e400d3667ac8c796e178fbf8f2740bb8feaba014"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"llama") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
