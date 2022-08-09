class Gcem < Formula
  desc "C++ compile-time math library"
  homepage "https://gcem.readthedocs.io/en/latest/"
  url "https://github.com/kthohr/gcem/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "ec570f4c4e4dab9a9e929b61fd9cc06303f4bd7943e5489e62fdd577016323b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad2736bb2676c04cc1064c2fd75ce8c4f67d87d4beadcf3a18690e636af7b9b8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <gcem.hpp>

      int main() {
        constexpr int x = 10;
        std::cout << gcem::factorial(x) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    assert_equal "3628800\n", shell_output("./test")
  end
end
