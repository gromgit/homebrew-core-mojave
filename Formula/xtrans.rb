class Xtrans < Formula
  desc "X.Org: X Network Transport layer shared code"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/xtrans-1.4.0.tar.bz2"
  sha256 "377c4491593c417946efcd2c7600d1e62639f7a8bbca391887e2c4679807d773"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xtrans"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    # Fedora systems do not provide sys/stropts.h
    inreplace "Xtranslcl.c", "# include <sys/stropts.h>", "# include <sys/ioctl.h>"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xtrans/Xtrans.h"

      int main(int argc, char* argv[]) {
        Xtransaddr addr;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
