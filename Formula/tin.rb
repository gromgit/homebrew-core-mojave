class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.6/tin-2.6.1.tar.xz"
  sha256 "9da27203e9f9066a76bcb76e94ad67d4f2384a2e9aaccacf518e91d03b9f1853"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tin"
    sha256 mojave: "45665f0274d0cb357dc9d1b94edd830b0ed0b5ebd5a9f6f214752a612629890a"
  end

  depends_on "gettext"

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
