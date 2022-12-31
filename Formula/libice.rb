class Libice < Formula
  desc "X.Org: Inter-Client Exchange Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libICE-1.1.1.tar.xz"
  sha256 "03e77afaf72942c7ac02ccebb19034e6e20f456dcf8dddadfeb572aa5ad3e451"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libice"
    sha256 cellar: :any, mojave: "d8ab681cf7735a100572593675a8f492f04c7f1aab2921c51085dbc1f47e8a96"
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libx11"=> :test
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/ICE/ICEutil.h"

      int main(int argc, char* argv[]) {
        IceAuthFileEntry entry;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
