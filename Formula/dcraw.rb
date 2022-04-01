class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.dechifro.org/dcraw/"
  url "https://www.dechifro.org/dcraw/archive/dcraw-9.28.0.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/dcraw/dcraw-9.28.0.tar.gz"
  sha256 "2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9"
  revision 1

  livecheck do
    url "https://distfiles.macports.org/dcraw/"
    regex(/href=.*?dcraw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dcraw"
    sha256 cellar: :any, mojave: "e9c32b8c306728da820f905dffee787dfacc5d180dfb89625631e1acf16ee27c"
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system ENV.cc, "-o", "dcraw", ENV.cflags, "dcraw.c", "-lm", "-ljpeg", "-llcms2", "-ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end

  test do
    assert_match "\"dcraw\" v9", shell_output("#{bin}/dcraw", 1)
  end
end
