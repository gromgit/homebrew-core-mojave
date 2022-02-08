class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/41/evince-41.3.tar.xz"
  sha256 "3346b01f9bdc8f2d5ffea92f110a090c64a3624942b5b543aad4592a9de33bb0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/evince"
    rebuild 1
    sha256 mojave: "f17d3b0e5f4ba0d857fd477674525ffe5e3e8402cf02ac796393a4abbc099c16"
  end

  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "python@3.9"

  # Fix compilation failure due to incorrect args for `i18n.merge_file`
  # https://gitlab.gnome.org/GNOME/evince/-/issues/1732
  patch do
    url "https://gitlab.gnome.org/GNOME/evince/-/commit/1060b24d051607f14220f148d2f7723b29897a54.diff"
    sha256 "5e9690beee8a472148a7c6fda78793a3499d5d0c38e08f61e1589598fab68f1a"
  end

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
