class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.0/osm-gps-map-1.2.0.tar.gz"
  sha256 "ddec11449f37b5dffb4bca134d024623897c6140af1f9981a8acc512dbf6a7a5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/osm-gps-map"
    rebuild 1
    sha256 mojave: "0a10a3cead270aea4d5255066a4966bf5afdc8252b3bf54e6d26e1c94be0f737"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libsoup@2"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    glib = Formula["glib"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    pango = Formula["pango"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{pango.opt_include}/pango-1.0
      -I#{include}/osmgpsmap-1.0
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lglib-2.0
      -lgtk-3
      -lgobject-2.0
      -lpango-1.0
      -losmgpsmap-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags

    on_linux do
      # (test:40601): Gtk-WARNING **: 23:06:24.466: cannot open display
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
