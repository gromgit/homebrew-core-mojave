class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://github.com/Neargye/magic_enum/archive/v0.8.1.tar.gz"
  sha256 "6b948d1680f02542d651fc82154a9e136b341ce55c5bf300736b157e23f9df11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "baf0da490410d3efae5760f9a0690b835a35bb37766ba223b9aaa2a19d4b443b"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc" # C++17
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "./test/test-cpp17"
    system "./test/test-cpp17"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <magic_enum.hpp>

      enum class Color : int { RED = -10, BLUE = 0, GREEN = 10 };

      int main() {
        Color c1 = Color::RED;
        auto c1_name = magic_enum::enum_name(c1);
        std::cout << c1_name << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++17", "-o", "test"
    assert_equal "RED\n", shell_output(testpath/"test")
  end
end
