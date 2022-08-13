class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-4.0.0.tar.xz"
  sha256 "8423f7069daa476307321d1c11e2ecc285340cd32ca9fc05207762843edeacbd"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://libvirt.org/sources/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvirt-glib"
    sha256 mojave: "882a41777adc3490305100a4f9df7c900c8fce6f5d351a32486b64a453646f86"
  end

  depends_on "glib-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "builddir", *std_meson_args, "-Dintrospection=enabled"
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libvirt-gconfig/libvirt-gconfig.h>
      #include <libvirt-glib/libvirt-glib.h>
      #include <libvirt-gobject/libvirt-gobject.h>
      int main() {
        gvir_config_object_get_type();
        gvir_event_register();
        gvir_interface_get_type();
        return 0;
      }
    EOS
    libxml2 = if OS.mac?
      "#{MacOS.sdk_path}/usr/include/libxml2"
    else
      Formula["libxml2"].opt_include/"libxml2"
    end
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libxml2}",
                    "-I#{Formula["glib"].include}/glib-2.0",
                    "-I#{Formula["glib"].lib}/glib-2.0/include",
                    "-I#{include}/libvirt-gconfig-1.0",
                    "-I#{include}/libvirt-glib-1.0",
                    "-I#{include}/libvirt-gobject-1.0",
                    "-L#{lib}",
                    "-lvirt-gconfig-1.0",
                    "-lvirt-glib-1.0",
                    "-lvirt-gobject-1.0",
                    "-o", "test"
    system "./test"
  end
end
