class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.20/libmtp-1.1.20.tar.gz"
  sha256 "c9191dac2f5744cf402e08641610b271f73ac21a3c802734ec2cedb2c6bc56d0"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmtp"
    sha256 cellar: :any, mojave: "bb99d78ded3feb477d372a05663ff10d2b4597a4ad07b1143e85d0059724559b"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz",
                          "--with-udev=#{lib}/udev"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
