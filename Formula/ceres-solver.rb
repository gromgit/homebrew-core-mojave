class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 1
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ceres-solver"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "82b2bd8c0e5b5aca62f6adbce1962396e30db0a02997fdae4a59e0eee8827849"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
