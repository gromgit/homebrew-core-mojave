class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.54.06/xmlrpc-c-1.54.06.tgz"
  sha256 "ae6d0fb58f38f1536511360dc0081d3876c1f209d9eaa54357e2bacd690a5640"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xmlrpc-c"
    sha256 cellar: :any, mojave: "a3ce1bdfc5466903424e515dab72451a28de3bb6bee36815f2558a1d14255e3b"
  end

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end
