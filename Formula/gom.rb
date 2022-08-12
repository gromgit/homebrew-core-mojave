class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gom"
    rebuild 1
    sha256 cellar: :any, mojave: "8816e1d7e68166ce89ad527439d30b70d8462c3128f36f1aafd2dc5a474423ac"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "sqlite"

  def install
    site_packages = prefix/Language::Python.site_packages("python3")

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpygobject-override-dir=#{site_packages}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
