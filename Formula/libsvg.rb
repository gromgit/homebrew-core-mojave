class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsvg"
    sha256 cellar: :any, mojave: "c3f597498e0d30d8f094715fb04062f0ffc4ab940a6cc1423bde5ec9fc428bd1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "libxml2"

  # Fix undefined reference to 'png_set_gray_1_2_4_to_8' in libpng 1.4.0+
  patch do
    url "https://raw.githubusercontent.com/buildroot/buildroot/45c3b0ec49fac67cc81651f0bed063722a48dc29/package/libsvg/0002-Fix-undefined-symbol-png_set_gray_1_2_4_to_8.patch"
    sha256 "a0ca1e25ea6bd5cb9aac57ac541c90ebe3b12c1340dbc5762d487d827064e0b9"
  end

  # Allow building on M1 Macs. This patch is adapted from
  # https://cgit.freedesktop.org/cairo/commit/?id=afdf3917ee86a7d8ae17f556db96478682674a76
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
      #include "svg.h"

      int main(int argc, char **argv) {
          svg_t *svg = NULL;
          svg_status_t result = SVG_STATUS_SUCCESS;
          FILE *fp = NULL;

          printf("1\\n");
          result = svg_create(&svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_create failed\\n");
              /* Fail if alloc failed */
              return -1;
          }

          printf("2\\n");
          result = svg_parse(svg, "test.svg");
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_parse failed\\n");
              /* Fail if alloc failed */
              return -2;
          }

          printf("3\\n");
          result = svg_destroy(svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_destroy failed\\n");
              /* Fail if alloc failed */
              return -3;
          }
          svg = NULL;

          printf("4\\n");
          result = svg_create(&svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_create failed\\n");
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
          result = svg_parse_file(svg, fp);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_parse_file failed\\n");
              /* Fail if alloc failed */
              return -6;
          }

          printf("6\\n");
          result = svg_destroy(svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_destroy failed\\n");
              /* Fail if alloc failed */
              return -7;
          }
          svg = NULL;
          printf("SUCCESS\\n");

          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsvg",
                   "-L#{Formula["libpng"].opt_lib}", "-lpng",
                   "-L#{Formula["jpeg-turbo"].opt_lib}", "-ljpeg",
                   "-Wl,-rpath,#{Formula["jpeg-turbo"].opt_lib}",
                   "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    assert_equal "1\n2\n3\n4\n5\n6\nSUCCESS\n", shell_output("./test")
  end
end

__END__
diff --git a/configure.in b/configure.in
index a9f871e..c84d417 100755
--- a/configure.in
+++ b/configure.in
@@ -8,18 +8,18 @@ LIBSVG_VERSION=0.1.4
 # libtool shared library version
 
 # Increment if the interface has additions, changes, removals.
-LT_CURRENT=1
+m4_define(LT_CURRENT, 1)
 
 # Increment any time the source changes; set to
 # 0 if you increment CURRENT
-LT_REVISION=0
+m4_define(LT_REVISION, 0)
 
 # Increment if any interfaces have been added; set to 0
 # if any interfaces have been removed. removal has
 # precedence over adding, so set to 0 if both happened.
-LT_AGE=0
+m4_define(LT_AGE, 0)
 
-VERSION_INFO="$LT_CURRENT:$LT_REVISION:$LT_AGE"
+VERSION_INFO="LT_CURRENT():LT_REVISION():LT_AGE()"
 AC_SUBST(VERSION_INFO)
 
 dnl ===========================================================================
