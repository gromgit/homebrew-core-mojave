class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.2.tar.gz"
  sha256 "4d8b84bd07b673d0ed41031348f10ca98dd6fa6a4460f9b9668d6f1d4084dfc8"
  license "MIT"
  revision 1
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bamtools"
    sha256 cellar: :any, mojave: "1dbb740b084f364e055a581568a10b981e666fa2540cccd946f5d3c5c05daecc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"

  uses_from_macos "zlib"

  def install
    # Delete bundled jsoncpp to avoid fallback
    (buildpath/"src/third_party/jsoncpp").rmtree

    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/src/libbamtools.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "api/BamWriter.h"
      using namespace BamTools;
      int main() {
        BamWriter writer;
        writer.Close();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/bamtools", "-L#{lib}",
                    "-lbamtools", "-lz", "-o", "test"
    system "./test"
  end
end
