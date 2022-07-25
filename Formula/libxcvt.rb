class Libxcvt < Formula
  desc "VESA CVT standard timing modelines generator"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/lib/libxcvt-0.1.2.tar.xz"
  sha256 "0561690544796e25cfbd71806ba1b0d797ffe464e9796411123e79450f71db38"
  license "MIT"
  head "https://gitlab.freedesktop.org/xorg/lib/libxcvt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxcvt"
    sha256 cellar: :any, mojave: "dd25650120fab89752d249af45096fcb0001da3363e63d81537837230d70624d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "build", *std_meson_args
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "1920", shell_output(bin/"cvt 1920 1200 75")

    (testpath/"test.c").write <<~EOS
      #include <libxcvt/libxcvt.h>
      #include <assert.h>
      #include <stdio.h>

      int main(void) {
        struct libxcvt_mode_info *pmi = libxcvt_gen_mode_info(1920, 1200, 75, false, false);
        assert(pmi->hdisplay == 1920);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcvt"
    system "./test"
  end
end
