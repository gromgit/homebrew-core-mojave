class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://deb.debian.org/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"
  license "GPL-2.0"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/c/corkscrew/"
    regex(/href=.*?corkscrew[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/corkscrew"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "e761b8cd21c285b7b8650ef1b67cf9d2d389a3bfaa715f67276385f72f465415"
  end

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"
    require "webrick"
    require "webrick/httpproxy"

    pid = fork do
      proxy = WEBrick::HTTPProxyServer.new Port: 8080
      proxy.start
    end

    sleep 1

    begin
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 8080 www.google.com 80") do |stdin, stdout, _|
        stdin.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
