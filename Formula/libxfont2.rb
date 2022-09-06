class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.6.tar.gz"
  sha256 "a944df7b6837c8fa2067f6a5fc25d89b0acc4011cd0bc085106a03557fb502fc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxfont2"
    sha256 cellar: :any, mojave: "3f06db120e15de26ec5271cd86b78f1b68a645ad15bab1962a531ff1a6f1c06a"
  end

  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => [:build, :test]
  depends_on "xtrans"      => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{Formula["xorgproto"].include}",
      "-L#{lib}", "-lXfont2"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
