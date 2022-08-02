class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.2.tar.xz"
  sha256 "ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pygobject3"
    sha256 cellar: :any, mojave: "26440b36aa1e19bd8afa1a1884f39e9334766e5376fdf37b80cf561f49dfc92b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      mkdir "buildpy3" do
        system "meson", *std_meson_args,
                        "-Dpycairo=enabled",
                        "-Dpython=#{python}",
                        "-Dpython.platlibdir=#{site_packages(python)}",
                        "-Dpython.purelibdir=#{site_packages(python)}",
                        ".."
        system "ninja", "-v"
        system "ninja", "install", "-v"
      end
      rm_rf "buildpy3"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pythons.each do |python|
      ENV.prepend_path "PYTHONPATH", site_packages(python)
      system python, "test.py"
    end
  end
end
