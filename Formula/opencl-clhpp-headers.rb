class OpenclClhppHeaders < Formula
  desc "C++ language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-CLHPP/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "999dec3ebf451f0f1087e5e1b9a5af91434b4d0c496d47e912863ac85ad1e6b2"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-CLHPP.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77525acc6124b241ec72b91b5d6fa5fdb681e823c58451a2d17ee98d43c9456d"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "opencl-headers"

  def install
    system "cmake", "-DBUILD_TESTING=OFF",
                    "-DBUILD_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-S", ".",
                    "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CL/opencl.hpp>
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-c", "-I#{include}", "-I#{Formula["opencl-headers"].include}"
  end
end
