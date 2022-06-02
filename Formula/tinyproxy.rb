class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.1/tinyproxy-1.11.1.tar.xz"
  sha256 "d66388448215d0aeb90d0afdd58ed00386fb81abc23ebac9d80e194fceb40f7c"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tinyproxy"
    sha256 mojave: "89e9ee4da3d7bfc8cae5dfd448df1c70d6e9bee9e56d671fb7d47ed5c51bf809"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
      --enable-filter
      --enable-reverse
      --enable-transparent
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  service do
    run [opt_bin/"tinyproxy", "-d"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    cp etc/"tinyproxy/tinyproxy.conf", testpath/"tinyproxy.conf"
    inreplace testpath/"tinyproxy.conf", "Port 8888", "Port #{port}"

    pid = fork do
      exec "#{bin}/tinyproxy", "-c", testpath/"tinyproxy.conf"
    end
    sleep 2

    begin
      assert_match "tinyproxy", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
