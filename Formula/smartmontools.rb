class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.3/smartmontools-7.3.tar.gz"
  sha256 "a544f8808d0c58cfb0e7424ca1841cb858a974922b035d505d4e4c248be3a22b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/smartmontools"
    sha256 mojave: "c35b667e808612233e8a77cd8a1c841eba03b5cafa12fc23c2fbd84fd504ee49"
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog",
                          "--with-nvme-devicescan"
    system "make", "install"
  end

  test do
    system "#{bin}/smartctl", "--version"
    system "#{bin}/smartd", "--version"
  end
end
