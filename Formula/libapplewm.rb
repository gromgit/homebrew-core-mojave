class Libapplewm < Formula
  desc "Xlib-based library for the Apple-WM extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libapplewm"
    sha256 cellar: :any, mojave: "6f79ad3f725adcee5e1884899b1db137f17f790022d492755142a5ac96277196"
  end

  depends_on "pkg-config" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on :macos

  def install
    # Use -iframeworkwithsysroot rather than -F to pick up
    # system headers from the SDK rather than the live filesystem
    # https://gitlab.freedesktop.org/xorg/lib/libapplewm/-/commit/be972ebc3a97292e7d2b2350eff55ae12df99a42
    # TODO: Remove in the next release
    inreplace "src/Makefile.in", "-F", "-iframeworkwithsysroot "
    system "./configure", *std_configure_args, "--with-sysroot=#{MacOS.sdk_path}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/Xlib.h>
      #include <X11/extensions/applewm.h>
      #include <stdio.h>

      int main(void) {
        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL) {
          fprintf(stderr, "Unable to connect to display\\n");
          return 0;
        }

        XAppleWMSetFrontProcess(disp);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-L#{lib}", "-L#{Formula["libx11"].lib}",
      "-lX11", "-lAppleWM"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
