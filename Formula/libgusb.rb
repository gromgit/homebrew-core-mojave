class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.9.tar.xz"
  sha256 "1f51ebe8c91140cffbd1c4d58602c96b884170cae4c74f6f7e302a91d5b7c972"
  license "LGPL-2.1-only"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  livecheck do
    url "https://people.freedesktop.org/~hughsient/releases/"
    regex(/href=.*?libgusb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgusb"
    rebuild 1
    sha256 mojave: "28d7a111d4a16b326da1b855f40a4e006179745a80087bceceabba5a3911ee64"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"
  depends_on "usb.ids"

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"

    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", "-Dusb_ids=#{Formula["usb.ids"].opt_share}/misc/usb.ids", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gusbcmd", "-h"
    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lusb-1.0
      -lgusb
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
