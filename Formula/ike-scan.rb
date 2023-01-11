class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.5.tar.gz"
  sha256 "5152bf06ac82d0cadffb93a010ffb6bca7efd35ea169ca7539cf2860ce2b263f"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/royhills/ike-scan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ike-scan"
    rebuild 3
    sha256 mojave: "44b897a0a80c5813b572d7b79eadf2e3c7d9a34c7d3e7d70afd4532c34a88afd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
