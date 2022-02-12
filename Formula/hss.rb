class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.9.tar.gz"
  sha256 "d7846ee657fe6a600c7d6f8e91f17ffa238efcaeb6f79856caa9fdedd96e3bca"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hss"
    sha256 cellar: :any, mojave: "345b80257b9046c71e7720751927b9552cc147bf6438b6731902377fb10a6ec2"
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    port = free_port
    begin
      server = TCPServer.new(port)
      accept_pid = fork do
        msg = server.accept.gets
        assert_match "SSH", msg
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec "#{bin}/hss", "-H", "-p #{port} 127.0.0.1", "-u", "root", "true",
          out: hss_write
      end
      server.close
      msg = hss_read.gets
      assert_match "Connection closed by remote host", msg
    ensure
      Process.kill("TERM", accept_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end
