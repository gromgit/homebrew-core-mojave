class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/3.32/gitg-3.32.1.tar.xz"
  sha256 "24a4aabf8a42aa2e783e1fb5996ebb3c2a82a01b9689269f1329517ef124ef5a"
  revision 6

  bottle do
    sha256 big_sur:  "b2451ec4e4ef9126af4cb262d58d03beda0a06fcad12c9200f206af46b277bd2"
    sha256 catalina: "6f9af292508a1a80622bc544f2aa182a46b63345ed8c9dc89e3034a9e2a2178d"
    sha256 mojave:   "c771ecd10a224156e0810d46d3834421c548a75080d6d239d30b714875a21065"
  end

  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "gtkspell3"
  depends_on "hicolor-icon-theme"
  depends_on "libdazzle"
  depends_on "libgee"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libpeas"
  depends_on "libsecret"
  depends_on "libsoup"

  # Fix libgitg compile on macOS from https://gitlab.gnome.org/GNOME/gitg/-/merge_requests/142
  # Remove for next version
  patch do
    url "https://gitlab.gnome.org/GNOME/gitg/-/commit/67f5cd6925e8bf1e4c7e5b65fe9370c2cdd1d273.diff"
    sha256 "b9b842d1be3e435ce14a57d30702138a0e08ba0f9ef95249876fc05aeac2417c"
  end

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # test executable
    assert_match version.to_s, shell_output("#{bin}/gitg --version")
    # test API
    (testpath/"test.c").write <<~EOS
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libgee = Formula["libgee"]
    libgit2 = Formula["libgit2"]
    libgit2_glib = Formula["libgit2-glib"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgitg-1.0
      -I#{libepoxy.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libgit2}/include
      -I#{libgit2_glib.opt_include}/libgit2-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DGIT_SSH=1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libgit2.opt_lib}
      -L#{libgit2_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lgirepository-1.0
      -lgit2
      -lgit2-glib-1.0
      -lgitg-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgthread-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
