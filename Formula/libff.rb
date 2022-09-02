class Libff < Formula
  desc "C++ library for Finite Fields and Elliptic Curves"
  homepage "https://github.com/scipr-lab/libff"
  # pull from git tag to get submodules
  url "https://github.com/scipr-lab/libff.git",
      tag:      "v0.2.1",
      revision: "5835b8c59d4029249645cf551f417608c48f2770"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libff"
    sha256 cellar: :any, mojave: "fdfa407274a35f7bc050d2085ec498aac38269fda3475513853276b0278ce884"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1" => :build

  depends_on "gmp"

  def install
    # bn128 is somewhat faster, but requires an x86_64 CPU
    curve = Hardware::CPU.intel? ? "BN128" : "ALT_BN128"

    # build libff dynamically. The project only builds statically by default
    inreplace "libff/CMakeLists.txt", "STATIC", "SHARED"

    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_PROCPS=OFF",
                    "-DCURVE=#{curve}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libff/algebra/curves/edwards/edwards_pp.hpp>

      using namespace libff;

      int main(int argc, char *argv[]) {
        edwards_pp::init_public_params();
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lff", "-o", "test"
    system "./test"
  end
end
