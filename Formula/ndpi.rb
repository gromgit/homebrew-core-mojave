class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/4.2.tar.gz"
  sha256 "e54ce8fe13adc5d747be7553513657fae78f796e0bd459e122c280cc06ce4daf"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ndpi"
    sha256 cellar: :any, mojave: "52633648f84bc23342b60f526b7fbfff8837c272bdd9f2b36e896481fb4d2c49"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
