class Libgdata < Formula
  desc "GLib-based library for accessing online service APIs"
  homepage "https://wiki.gnome.org/Projects/libgdata"
  url "https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.1.tar.xz"
  sha256 "dd8592eeb6512ad0a8cf5c8be8c72e76f74bfe6b23e4dd93f0756ee0716804c7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgdata"
    rebuild 3
    sha256 cellar: :any, mojave: "393b5607a2e3237f35fb5eaa7127b3847d2dabffc50fb577a029a38f4c51429d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "liboauth"
  depends_on "libsoup@2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    curl_lib = OS.mac? ? MacOS.sdk_path_if_needed/"usr/lib" : Formula["curl"].opt_lib
    ENV.append "LDFLAGS", "-L#{curl_lib} -lcurl"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dintrospection=true",
        "-Doauth1=enabled",
        "-Dalways_build_tests=false",
        "-Dvapi=true",
        "-Dgtk=enabled",
        "-Dgoa=disabled",
        "-Dgnome=disabled",
        ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdata/gdata.h>

      int main(int argc, char *argv[]) {
        GType type = gdata_comment_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    liboauth = Formula["liboauth"]
    libsoup = Formula["libsoup@2"]
    libxml2_prefix = OS.mac? ? MacOS.sdk_path_if_needed/"usr" : Formula["libxml2"].opt_prefix
    curl_lib = OS.mac? ? MacOS.sdk_path_if_needed/"usr/lib" : Formula["curl"].opt_lib
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgdata
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{liboauth.opt_include}
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{libxml2_prefix}/include/libxml2
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{curl_lib}
      -L#{lib}
      -lgdata
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
      -lcurl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
