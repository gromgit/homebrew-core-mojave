class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.12.tar.gz"
  sha256 "e38e0a97b30a97b4355da93467160a20dea10932f6c17473774802e03d61d4a7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iperf3"
    sha256 cellar: :any, mojave: "a1271bb467a6a49c71e3c22aa4c84a95560ac298e7082be70f3f3737a30cfca9"
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
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
