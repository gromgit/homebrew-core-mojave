class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.14.tar.gz"
  sha256 "18861cc64dfffc0e7fe317b0eeb935adf64858fd5d82004894c4906d909dabf8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxpm"
    sha256 cellar: :any, mojave: "30fcdf92b659c330a71fb4083bd3bd28fba8c64758f4c7d0ae8f6e1dbae51743"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libx11"

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
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
