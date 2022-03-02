class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.6.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.6.tar.xz"
  sha256 "84d59cc22cb20ffac9cbea6c97b35d1d7e4993e7b1221fa5e82bcb0f03b9066d"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/epic5"
    rebuild 1
    sha256 mojave: "0964f73d26e4acfc472bc6c9c51911b67e7c4c944486b00224d414a9a42f49eb"
  end


  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
