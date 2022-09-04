class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.14.tar.gz"
  sha256 "12582a87a1f043ce77005590ef1060e92ad36ec07ccf132da49c59f857d413ee"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "util-linux" # for libuuid
  end

  fails_with gcc: "5"

  def python3
    which("python3.10")
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-GNinja",
                    "-DGDCM_BUILD_APPLICATIONS=ON",
                    "-DGDCM_BUILD_SHARED_LIBS=ON",
                    "-DGDCM_BUILD_TESTING=OFF",
                    "-DGDCM_BUILD_EXAMPLES=OFF",
                    "-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF",
                    "-DGDCM_USE_VTK=OFF", # No VTK 9 support: https://sourceforge.net/p/gdcm/bugs/509/
                    "-DGDCM_USE_SYSTEM_EXPAT=ON",
                    "-DGDCM_USE_SYSTEM_ZLIB=ON",
                    "-DGDCM_USE_SYSTEM_UUID=ON",
                    "-DGDCM_USE_SYSTEM_OPENJPEG=ON",
                    "-DGDCM_USE_SYSTEM_OPENSSL=ON",
                    "-DGDCM_WRAP_PYTHON=ON",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DPYTHON_INCLUDE_DIR=#{python_include}",
                    "-DGDCM_INSTALL_PYTHONMODULE_DIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    "-DGDCM_NO_PYTHON_LIBS_LINKING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      #include "gdcmReader.h"
      int main(int, char *[])
      {
        gdcm::Reader reader;
        reader.SetFileName("file.dcm");
      }
    EOS

    system ENV.cxx, "-std=c++11", "-isystem", "#{include}/gdcm-3.0", "-o", "test.cxx.o", "-c", "test.cxx"
    system ENV.cxx, "-std=c++11", "test.cxx.o", "-o", "test", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    system python3, "-c", "import gdcm"
  end
end
