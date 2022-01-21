class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.20/aravis-0.8.20.tar.xz"
  sha256 "0c0eb5a76109f29180c09c7e6a23fd403633bf22bbe8468a0ae44995c4449f46"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aravis"
    sha256 mojave: "b0421861ea0448a46e00c585b06c8126b5488b14613288dcd44090057c5ecebf"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.dylib")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
