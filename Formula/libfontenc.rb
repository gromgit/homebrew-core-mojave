class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.6.tar.gz"
  sha256 "c103543a47ce5c0200fb1867f32df5e754a7c3ef575bf1fe72187117eac22a53"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libfontenc"
    sha256 cellar: :any, mojave: "6f8bd2bce00de5ada7825996bcd47835185c761ec320fa6c77cc65c9ad126d17"
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
