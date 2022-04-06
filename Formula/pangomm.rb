class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.50/pangomm-2.50.0.tar.xz"
  sha256 "a27aa77e017b9afce9e751d85bd1cf890abbb3a58bf59d0fac917eef82db3b5b"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pangomm"
    rebuild 1
    sha256 cellar: :any, mojave: "395c4ba6cebad6d9860d510ed2e7e43688cf6b87d33ff01f9ef829042f782c10"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.16
      -I#{cairomm.opt_lib}/cairomm-1.16/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.68
      -I#{glibmm.opt_include}/glibmm-2.68
      -I#{glibmm.opt_lib}/giomm-2.68/include
      -I#{glibmm.opt_lib}/glibmm-2.68/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pangomm-2.48
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/pangomm-2.48/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lcairo
      -lcairomm-1.16
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-2.48
      -lsigc-3.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
