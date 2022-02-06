class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.70/gobject-introspection-1.70.0.tar.xz"
  sha256 "902b4906e3102d17aa2fcb6dad1c19971c70f2a82a159ddc4a94df73a3cafc4a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobject-introspection"
    rebuild 2
    sha256 mojave: "6ec9e83ea7da7ef5b4f8660707bed542c7c69b31a062591e5024b69e73807583"
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

  if Hardware::CPU.arm?
    # Series of seven commits from MR-301 to Fix SEGV on Apple Silicon Macs
    # See: https://github.com/Homebrew/homebrew-core/issues/88801
    #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/301
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/62c3c955547599a58786f20497748569c148379e.diff"
      sha256 "2c02a6c15cf225df6841be264ea073d7f7949da2ba5c9a8327cb25c4bb87d075"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/2a4dede7c2fdc3e6a6a5b063449ab3a8c58c11c0.diff"
      sha256 "96ad396093968a01a9d564b211c261632e9e3da386e9b8072c177a8e6cee9842"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/55a18f528e490f17c7fd5d790cca6075bb375c51.diff"
      sha256 "2871add72ac041be97ea12591f28cd51375da4c55c1549191969f7f7e9d4ee18"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/d81cad5ec57edb38f23b358c83e598c1609029a2.diff"
      sha256 "91c4b9c8e345432c5f59b270ffd5a75f3e01c88952d0f230a7736a45db01858e"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/3da41e13054dfe162dfa3a3ff750009f4aba745f.diff"
      sha256 "b7dad6558aaabad0061d2d8864ac9b1fda8c17e864e0774244aab2563657c827"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/f8ea3c90de233c635d502760ebff78c12390f9cf.diff"
      sha256 "ecbd845dfcd7da7ae757b87f9af5df9611d444621f5f00be38c2a12fbeb80dd0"
    end
    patch do
      url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/d4d5fb294a89c5c25f966f5e8407d335c315b1c1.diff"
      sha256 "8995b7153844bf311064c9b9a3d87781f8c8ae53274a2376eb5a53137aee7117"
    end
  end
  # Fix compatibility with PyInstaller on Monterey.
  # See: https://github.com/pyinstaller/pyinstaller/issues/6354
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/303
  patch do
    url "https://gitlab.gnome.org/rokm/gobject-introspection/-/commit/56df7b0f007fe260b2bd26ef9cc331ad73022700.diff"
    sha256 "56312cd45b2b3a7fd74eaae89843a49b9a06d1423785fb57416a8a61b1cb811f"
  end

  # Upstream patch for doctemplates error
  # Review for removal at version bump
  # See: https://gitlab.gnome.org/GNOME/gobject-introspection/-/issues/414
  patch do
    url "https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/effb1e09dee263cdac4ec593e8caf316e6f01fe2.diff"
    sha256 "e0f4932f230a26563c0948b83d3ec347b7ecd195503a6d4f1519a276a8022b95"
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
