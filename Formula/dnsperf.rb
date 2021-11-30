class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.8.0.tar.gz"
  sha256 "d50b9e05d9688a7b5906447cdca87bf1d8e100b5288e0081db6c3cdd0fea19b3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnsperf"
    rebuild 1
    sha256 cellar: :any, mojave: "327d4ce4aaa8d90c698137805a264db5a40d05c9253cbb77f99c7059c5c45530"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
