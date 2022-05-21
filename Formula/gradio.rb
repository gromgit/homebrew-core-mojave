class Gradio < Formula
  desc "GTK3 app for finding and listening to internet radio stations"
  homepage "https://github.com/haecker-felix/Gradio"
  url "https://github.com/haecker-felix/Gradio/archive/v7.3.tar.gz"
  sha256 "5c5afed83fceb9a9f8bc7414b8a200128b3317ccf1ed50a0e7321ca15cf19412"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gradio"
    rebuild 1
    sha256 mojave: "074b2356c03dc99331b1cc1ff2b6553ac0b75bc101a80b5ac5dee7325ab0567b"
  end

  deprecate! date: "2019-11-16", because: :repo_archived

  depends_on "graphviz" => :build # for vala
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libsoup@2"
  depends_on "python@3.7"

  uses_from_macos "bison" => :build # for vala
  uses_from_macos "flex" => :build # for vala

  # Fails to build with vala >= 0.56
  resource "vala" do
    url "http://download.gnome.org/sources/vala/0.54/vala-0.54.8.tar.xz"
    sha256 "edfb3e79486a4bf48cebaea9291e57fc77da9322b6961e9549df6d973d04bc80"
  end

  def install
    resource("vala").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{buildpath}/vala"
      system "make" # Fails to compile as a single step
      system "make", "install"
      ENV.prepend_path "PATH", buildpath/"vala/bin"
    end

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gradio", "-h" if ENV["DISPLAY"]
  end
end
