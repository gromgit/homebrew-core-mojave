class Khiva < Formula
  desc "Algorithms to analyse time series"
  homepage "https://khiva.readthedocs.io/"
  url "https://github.com/shapelets/khiva.git",
      tag:      "v0.5.0",
      revision: "c2c72474f98ce3547cbde5f934deabb1b4eda1c9"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/khiva"
    rebuild 2
    sha256 cellar: :any, mojave: "152cf25119ba8bd26c538e78caea3fb1a8bc1ae4e55df4eb22105bf5f945edee"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "arrayfire"
  depends_on "eigen"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DKHIVA_USE_CONAN=OFF",
                    "-DKHIVA_BUILD_TESTS=OFF",
                    "-DKHIVA_BUILD_BENCHMARKS=OFF",
                    "-DKHIVA_BUILD_JNI_BINDINGS=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/matrixExample.cpp", testpath
    system ENV.cxx, "-std=c++11", "matrixExample.cpp",
                    "-L#{Formula["arrayfire"].opt_lib}", "-laf",
                    "-L#{lib}", "-lkhiva",
                    "-o", "test"
    system "./test"
  end
end
