class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.28.tar.gz"
  sha256 "fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djvulibre"
    sha256 mojave: "968cfea4b7b8bda1f02d783d7418184b3436fe522be2ab06a852332b190989e2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
