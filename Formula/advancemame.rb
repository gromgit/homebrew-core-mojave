class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/advancemame"
    rebuild 1
    sha256 mojave: "ed1174a4fc7bcf0efb19c48bf2f5d18bd97c630835a8d81996a9b73d36b2c44a"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype",
                          "--enable-sdl2"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
