class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.6.tar.xz"
  sha256 "52733c1f5262fca35f64e7d5060c6fcd81a880ba8e1e65c9621cf0727afb5d11"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxdamage"
    sha256 cellar: :any, mojave: "a3609cf50fa6e7d6a5df82b1da5d01beee588b47310cca7e69130b932e4abe23"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "xorgproto"

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
      #include "X11/extensions/Xdamage.h"

      int main(int argc, char* argv[]) {
        XDamageNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
