class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  mirror "https://fossies.org/linux/www/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+))\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lynx"
    rebuild 2
    sha256 mojave: "817a275a6759095daa0c4fc0e31cd9478255a5751fe01656b0b1e86951fd14da"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Using --with-screen=ncurses to due to behaviour change in Big Sur
    # https://github.com/Homebrew/homebrew-core/pull/58019

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--enable-ipv6",
                          "--with-screen=ncurses",
                          "--enable-externs",
                          "--disable-config-info"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end
