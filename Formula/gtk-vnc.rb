class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz"
  sha256 "512763ac4e0559d0158b6682ca5dd1a3bd633f082f5e4349d7158e6b5f80f1ce"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gtk-vnc"
    sha256 mojave: "a70a80ef57602259661209819013b117ef2357d3674071bafd04cc665455a464"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-vala=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gvnccapture", "--help"
  end
end
