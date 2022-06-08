class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.3-src/pyside-setup-opensource-src-5.15.3.tar.xz"
  sha256 "7ff5f1cc4291fffb6d5a3098b3090abe4d415da2adec740b4e901893d95d7137"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pyside@2"
    sha256 cellar: :any, mojave: "f6ad236b7124a1f9e041af235ffa7d8df21d580a9a55ec882f5d090ea66919a1"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "qt@5"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DFORCE_LIMITED_API=yes
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

    system python, "-c", "import PySide2"
    system python, "-c", "import shiboken2"

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

    modules.each { |mod| system python, "-c", "import PySide2.Qt#{mod}" }

    pyincludes = shell_output("#{python}-config --includes").chomp.split
    pylib = shell_output("#{python}-config --ldflags --embed").chomp.split

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
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.abi3",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
