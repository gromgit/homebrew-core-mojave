class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.2-src/pyside-setup-opensource-src-5.15.2.tar.xz"
  sha256 "b306504b0b8037079a8eab772ee774b9e877a2d84bab2dbefbe4fa6f83941418"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pyside@2"
    rebuild 2
    sha256 cellar: :any, mojave: "b34be0a9ad379469a820bab62adb33356975bfb9f5eb4130f15e00ffad59c467"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt@5"

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -GNinja
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python#{xy}
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja", "install"
    end
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken2"

    modules = %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ]

    # Qt web engine is not supported on Apple Silicon.
    modules << "WebEngineWidgets" unless Hardware::CPU.arm?

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].opt_bin/"python3").to_s.delete(".")

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.cpython-#{pyver}-darwin",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
