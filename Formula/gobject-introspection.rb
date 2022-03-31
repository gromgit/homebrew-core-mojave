class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.72/gobject-introspection-1.72.0.tar.xz"
  sha256 "02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobject-introspection"
    sha256 mojave: "07ab59fc7fc3d75077e5665a8f9db261582f305c5bc2cb8fe103fcfd4a14b82b"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        revision: "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpython=#{Formula["python@3.9"].opt_bin}/python3",
        "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
        ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      rewrite_shebang detected_python_shebang, *bin.children
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
