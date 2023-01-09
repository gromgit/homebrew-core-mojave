class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://wiki.gnome.org/Projects/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/3.0/goocanvas-3.0.0.tar.xz"
  sha256 "670a7557fe185c2703a14a07506156eceb7cea3b4bf75076a573f34ac52b401a"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goocanvas"
    sha256 mojave: "53d3d4ebb60a7ff09738699f2126ac39972ad4f9bdc1238620f13ab3c3452d4a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-gtk-doc-html",
                          "--disable-silent-rules",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
