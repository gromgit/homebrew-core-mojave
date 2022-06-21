class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.1.tar.xz"
  sha256 "b79ce0cc4b0c66d9c54bc22183a10e5709a0011d2af272025948efcab33a3e4f"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gupnp-av"
    sha256 mojave: "6cb26d9eafe718039c8a3962d600846b641a2377895bb12d04bf0e190463081e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
