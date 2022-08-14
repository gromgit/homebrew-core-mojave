class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"
  license "LGPL-2.1"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?svg2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/svg2png"
    sha256 cellar: :any, mojave: "d1fd9c449e3994adb9931407389a4567a98a6acb5100edad681da4c5917e46ae"
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/Makefile.in", "$(LINK) $(svg2png_LDFLAGS) $(svg2png_OBJECTS)",
                                   "$(LINK) $(svg2png_OBJECTS) $(svg2png_LDFLAGS)"
    end

    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/svg2png", test_fixtures("test.svg"), "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
