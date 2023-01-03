class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.11.tar.gz"
  mirror "https://fossies.org/linux/privat/unixODBC-2.3.11.tar.gz"
  sha256 "d9e55c8e7118347e3c66c87338856dad1516b490fb7c756c1562a2c267c73b5c"
  license "LGPL-2.1-or-later"

  livecheck do
    url "http://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unixodbc"
    rebuild 1
    sha256 mojave: "1811dc21f7eea13c635f2fb7d68617c5adc215fad32b82ce04118dc94b264ca7"
  end

  depends_on "libtool"

  conflicts_with "libiodbc", because: "both install `odbcinst.h`"
  conflicts_with "virtuoso", because: "both install `isql` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
