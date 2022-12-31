class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.7.tar.xz"
  sha256 "79f0b37c45007381c371a790c2754644ad955166dbf2a48e3625032e9bdd4f71"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxft"
    sha256 cellar: :any, mojave: "f7331969b2b39f8896a7542364c2f19fce4d07eb55b4810ddfe4da0cbaf68622"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
