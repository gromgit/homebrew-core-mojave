class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.42.2.tar.gz"
  sha256 "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pixman"
    sha256 cellar: :any, mojave: "52e33bde78ada21065c910bd6b217a6b2aaa4a90a460bd19430c5141b4a9956f"
  end

  depends_on "pkg-config" => :build

  def install
    args = ["--disable-gtk", "--disable-silent-rules"]
    # Disable NEON intrinsic support on macOS
    # Issue ref: https://gitlab.freedesktop.org/pixman/pixman/-/issues/59
    # Issue ref: https://gitlab.freedesktop.org/pixman/pixman/-/issues/69
    args << "--disable-arm-a64-neon" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
