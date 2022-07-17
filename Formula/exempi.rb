class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.2.tar.bz2"
  sha256 "4d17d4c93df2a95da3e3172c45b7a5bf317dd31dafd1c7a340169728c7089d1d"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exempi"
    sha256 cellar: :any, mojave: "aad9384ae22f1ef3eb8785f415764e07313f63ec8c6b2fe6c5d9cf54b0901187"
  end

  depends_on "boost"

  uses_from_macos "expat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
