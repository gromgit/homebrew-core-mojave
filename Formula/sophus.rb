class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https://strasdat.github.io/Sophus/"
  url "https://github.com/strasdat/Sophus/archive/refs/tags/v22.04.1.tar.gz"
  sha256 "635dc536e7768c91e89d537608226b344eef901b51fbc51c9f220c95feaa0b54"
  license "MIT"
  revision 1
  head "https://github.com/strasdat/Sophus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01dc489f067505c1f4cec647efaf37da33a1a7e73ae6043b49e91ca986265e65"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ceres-solver"
  depends_on "eigen"

  fails_with gcc: "5" # C++17 (ceres-solver dependency)

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SOPHUS_EXAMPLES=OFF",
                    "-DSOPHUS_USE_BASIC_LOGGING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/HelloSO3.cpp"
  end

  test do
    cp pkgshare/"examples/HelloSO3.cpp", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(HelloSO3)
      add_compile_definitions(SOPHUS_USE_BASIC_LOGGING)
      find_package(Sophus REQUIRED)
      add_executable(HelloSO3 HelloSO3.cpp)
      target_link_libraries(HelloSO3 Sophus::Sophus)
    EOS

    system "cmake", "-DSophus_DIR=#{share}/Sophus", "."
    system "make"
    assert_match "The rotation matrices are", shell_output("./HelloSO3")
  end
end
