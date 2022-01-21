class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.2.tar.xz"
  sha256 "6de49ef4b375b8a164f74b766168b1184e0d28196b6b07a4f5341f08dfd85d6c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gupnp-tools"
    sha256 mojave: "e4deea7dfd69e7e0f904fe1376ba1a67f1939cd7ab4e0fcee2d5f5393c8e31c8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup@2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
