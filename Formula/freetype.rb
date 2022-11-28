class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.12.1/freetype-2.12.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.xz"
  sha256 "4766f20157cc4cf0cd292f80bf917f92d1c439b243ac3018debf6b9140c41a7f"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/freetype"
    rebuild 2
    sha256 cellar: :any, mojave: "220fa0a5235dae68d0fbe6a22e2e808b8efc5dbb8af7489a90b499b7931efac3"
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
