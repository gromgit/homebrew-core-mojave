class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.1.0.tar.gz"
  sha256 "c252b2d9537e18046d8b82535069d2567f77043f8e644acf9a9fffc22ea6e6f7"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/catch2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "305fa14d0e2893e965d4311ce21a327eebaad83f8d87f69f40b6e9919598e506"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <catch2/catch_all.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end
