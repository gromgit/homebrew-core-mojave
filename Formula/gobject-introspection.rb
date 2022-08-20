class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.72/gobject-introspection-1.72.0.tar.xz"
  sha256 "02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobject-introspection"
    sha256 mojave: "a8e6d332eb75c7730fe57fb4d556951c2db00d35dda0f7a5854f09b53a60329d"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # TODO: Consider using `uses_from_macos "python"` instead.
  depends_on "python@3.10"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

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

    system "meson", "setup", "build", "-Dpython=#{Formula["python@3.10"].opt_bin}/python3.10",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
