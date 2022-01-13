class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search wih KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://github.com/jlblancoc/nanoflann/archive/v1.4.1.tar.gz"
  sha256 "4e66edac66cef76460ae5b22c92806b999b16e05bb5b3b3ce2ada320d0bfa7a9"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d99918c46fed2a8a0d7485fe426bcfdfa50eba09d72579d3001337d4ecc4d3a3"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "https://bugs.llvm.org/show_bug.cgi?id=23029"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DNANOFLANN_BUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
