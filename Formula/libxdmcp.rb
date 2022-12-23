class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdmcp-1.1.4.tar.xz"
  sha256 "2dce5cc317f8f0b484ec347d87d81d552cdbebb178bd13c5d8193b6b7cd6ad00"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxdmcp"
    sha256 cellar: :any, mojave: "891e23558b50dac85e57b34f2895f1aba9fd3e4d18bd80296c54c9e02f104ff6"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
