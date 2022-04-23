class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcursor-1.2.1.tar.xz"
  sha256 "46c143731610bafd2070159a844571b287ac26192537d047a39df06155492104"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxcursor"
    sha256 cellar: :any, mojave: "3a7942d3bf3fe3f659c01a7af8be2b897de4edb76f3530c6536040ddfefc0cbd"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

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
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
