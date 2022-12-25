class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v3.2.1.tar.gz"
  sha256 "4613d3e8142b672159fcae252a4860d72c8cf8e2df5043b1ae3541db9ef5d73c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/catch2"
    sha256 cellar: :any_skip_relocation, mojave: "c5d57196fb54a137502a009220f95189cc3d82dd4af9872b057e75ed12d51489"
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
