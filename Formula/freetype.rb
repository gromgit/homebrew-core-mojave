class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.11.1/freetype-2.11.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.11.1.tar.xz"
  sha256 "3333ae7cfda88429c97a7ae63b7d01ab398076c3b67182e960e5684050f2c5c8"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/freetype"
    rebuild 1
    sha256 cellar: :any, mojave: "54476b8d883fe5bfd1f4ed78d9d6d21d6ab80f9ad09a477a9f65bc40915b5c67"
  end

  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
