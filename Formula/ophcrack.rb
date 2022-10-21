class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ophcrack"
    rebuild 1
    sha256 cellar: :any, mojave: "6c348eaf4592af82573797942e1d4ac68f98fae93b3f2a10421df0661c67d4a9"
  end

  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    args = %W[
      --disable-debug
      --disable-gui
      --with-libssl=#{Formula["openssl@3"].opt_prefix}
      --prefix=#{prefix}
    ]
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
