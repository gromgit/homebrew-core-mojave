class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.5.tar.gz"
  sha256 "5152bf06ac82d0cadffb93a010ffb6bca7efd35ea169ca7539cf2860ce2b263f"
  license "GPL-3.0-or-later"
  head "https://github.com/royhills/ike-scan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ike-scan"
    rebuild 1
    sha256 mojave: "88728ac1f5b9a1f5b902538c2054a9cea44e814565a51251db8bb1336563aa0a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
