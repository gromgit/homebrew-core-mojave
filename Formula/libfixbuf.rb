class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.1.tar.gz"
  sha256 "8c535d48120b08df1731de709f2dbd2ba8bce568ad64cac34826102caf594d84"
  license "LGPL-3.0-only"

  livecheck do
    url "https://tools.netsa.cert.org/fixbuf/download.html"
    regex(%r{releases/libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libfixbuf"
    rebuild 1
    sha256 mojave: "90b1cb3c690cc550884e49dbef8e4a36fd54e5544ae244975ad98b112da81381"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
