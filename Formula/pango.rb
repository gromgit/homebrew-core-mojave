class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.50/pango-1.50.11.tar.xz"
  sha256 "8800f812d89ee61388188703203f3a7878963c22f8695aaf1fa0a1a1428d17ae"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pango"
    sha256 cellar: :any_skip_relocation, mojave: "a0dc6c980db88a5b9478fcb2df682639c6a398ba67adca12a20ee6713bd48148"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"

  def install
    system "meson", *std_meson_args, "build",
                    "-Ddefault_library=both",
                    "-Dintrospection=enabled",
                    "-Dfontconfig=enabled",
                    "-Dcairo=enabled",
                    "-Dfreetype=enabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"pango-view", "--version"
    (testpath/"test.c").write <<~EOS
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
