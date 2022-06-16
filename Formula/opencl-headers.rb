class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2022.05.18.tar.gz"
  sha256 "88a1177853b279eaf574e2aafad26a84be1a6f615ab1b00c20d5af2ace95c42e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opencl-headers"
    sha256 cellar: :any_skip_relocation, mojave: "60b2ccfedf9128ca15a2e63e5526981c3a9d3d1ab339987c9f585d5bf3e12afd"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
