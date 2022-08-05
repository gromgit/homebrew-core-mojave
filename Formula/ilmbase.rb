class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v2.5.8.tar.gz"
  sha256 "db261a7fcc046ec6634e4c5696a2fc2ce8b55f50aac6abe034308f54c8495f55"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ilmbase"
    sha256 cellar: :any, mojave: "a037f58a502578b047e6b89346f5b2db94a7695bac10a9b4a55059437afc8469"
  end

  keg_only "ilmbase conflicts with `openexr` and `imath`"

  # https://github.com/AcademySoftwareFoundation/openexr/pull/929
  # Commented out while this formula still has dependents.
  # deprecate! date: "2021-04-05", because: :unsupported

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
