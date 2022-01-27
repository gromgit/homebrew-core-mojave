class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.4.tar.bz2"
  sha256 "59ad6fcce98deaecc14d39a672cf218ca37aba617c9a0f691cac3bcd28edf82b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxext"
    rebuild 1
    sha256 cellar: :any, mojave: "8dd3f381ef96f4cbd4ac73f0f5a7a0f307a6be60eabc605d50c581f1c5616a9e"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
