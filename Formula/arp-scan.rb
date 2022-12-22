class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.10.0.tar.gz"
  sha256 "204b13487158b8e46bf6dd207757a52621148fdd1d2467ebd104de17493bab25"
  license "GPL-3.0"
  head "https://github.com/royhills/arp-scan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arp-scan"
    sha256 mojave: "629bc3f21b2f306211d8d75ba4faec885febbbde746cc2d13f13757eecac7c66"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
