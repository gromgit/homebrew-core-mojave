class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  license "LGPL-2.1"
  revision 3

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg-cairo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsvg-cairo"
    sha256 cellar: :any, mojave: "81d763eb698d7b78b9869f65ef700b7d7a6896309d0a03631c2d0a041089883e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsvg"

  # libsvg: fix for ARM/M1 Macs
  # Patch to update to newer autotools
  # (https://cgit.freedesktop.org/cairo/commit/?id=afdf3917ee86a7d8ae17f556db96478682674a76)
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg xmlns:svg="http://www.w3.org/2000/svg" height="72pt" width="144pt" viewBox="0 -20 144 72"><text font-size="12" text-anchor="left" y="0" x="0" font-family="Times New Roman" fill="green">sample text here</text></svg>
    EOS

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "svg-cairo.h"

      int main(int argc, char **argv) {
          svg_cairo_t *svg = NULL;
          svg_cairo_status_t result = SVG_CAIRO_STATUS_SUCCESS;
          FILE *fp = NULL;
          printf("1\\n");
          result = svg_cairo_create(&svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_create failed: %d\\n", result);
              /* Fail if alloc failed */
              return -1;
          }
          printf("2\\n");
          result = svg_cairo_parse(svg, "test.svg");
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_parse failed: %d\\n", result);
              /* Fail if alloc failed */
              return -2;
          }
          printf("3\\n");
          result = svg_cairo_destroy(svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_destroy failed: %d\\n", result);
              /* Fail if alloc failed */
              return -3;
          }
          svg = NULL;
          printf("4\\n");
          result = svg_cairo_create(&svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_create failed: %d\\n", result);
              /* Fail if alloc failed */
              return -4;
          }
          fp = fopen("test.svg", "r");
          if (NULL == fp) {
              printf ("failed to fopen test.svg\\n");
              /* Fail if alloc failed */
              return -5;
          }
          printf("5\\n");
          result = svg_cairo_parse_file(svg, fp);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_parse_file failed: %d\\n", result);
              /* Fail if alloc failed */
              return -6;
          }
          printf("6\\n");
          result = svg_cairo_destroy(svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_destroy failed: %d\\n", result);
              /* Fail if alloc failed */
              return -7;
          }
          svg = NULL;
          printf("SUCCESS\\n");
          return 0;
      }
    EOS

    cairo = Formula["cairo"]
    system ENV.cc, "test.c", "-I#{include}", "-I#{cairo.opt_include}/cairo", "-L#{lib}", "-lsvg-cairo", "-o", "test"
    assert_equal "1\n2\n3\n4\n5\n6\nSUCCESS\n", shell_output("./test")
  end
end

__END__
diff --git a/configure.in b/configure.in
index 3407e0d..627bbc5 100755
--- a/configure.in
+++ b/configure.in
@@ -8,18 +8,18 @@ LIBSVG_CAIRO_VERSION=0.1.6
 # libtool shared library version

 # Increment if the interface has additions, changes, removals.
-LT_CURRENT=1
+m4_define(LT_CURRENT, 1)

 # Increment any time the source changes; set to
 # 0 if you increment CURRENT
-LT_REVISION=1
+m4_define(LT_REVISION, 1)

 # Increment if any interfaces have been added; set to 0
 # if any interfaces have been removed. removal has
 # precedence over adding, so set to 0 if both happened.
-LT_AGE=0
+m4_define(LT_AGE, 0)

-VERSION_INFO="$LT_CURRENT:$LT_REVISION:$LT_AGE"
+VERSION_INFO="LT_CURRENT():LT_REVISION():LT_AGE()"
 AC_SUBST(VERSION_INFO)

 dnl ===========================================================================
