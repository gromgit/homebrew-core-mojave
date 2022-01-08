class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.48.tar.xz"
  sha256 "ff86d7f1d46dd0ebefb7bd830a74a41db64362b987bf8853fff6ab4c1132b837"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgsf"
    sha256 mojave: "6e85fb864af0811c4377c33dc7ed9669040db8afbc4ec76bbfa524cf6746a04c"
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "libxml2"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~EOS
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
