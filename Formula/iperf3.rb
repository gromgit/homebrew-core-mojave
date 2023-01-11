class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.12.tar.gz"
  sha256 "72034ecfb6a7d6d67e384e19fb6efff3236ca4f7ed4c518d7db649c447e1ffd6"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iperf3"
    rebuild 1
    sha256 cellar: :any, mojave: "d8d614d9566b81bdd98ae88ab65c630da33286250c5b3d288f24dd8ef0884b70"
  end

  head do
    url "https://github.com/esnet/iperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf3 --server")
    sleep 1
    assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
