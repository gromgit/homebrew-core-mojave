class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/doctest/doctest"
  url "https://github.com/doctest/doctest/archive/v2.4.9.tar.gz"
  sha256 "19b2df757f2f3703a5e63cee553d85596875f06d91a3333acd80a969ef210856"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e5ebc4806487a67ed7207327f42484a1f9e0ef79616ed1b67d09d25d98629cf"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
