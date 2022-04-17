class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.10-source.zip"
  sha256 "417b5d5ff2df0c3a642fc7c56b7754344ed28b5aab861e9e8c8982663fa76762"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/antlr4-cpp-runtime"
    sha256 cellar: :any, mojave: "0f3192bb8249b54d0ac6225951c4fd84a41b6b4f0fdcb8f779be644a712ae378"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "util-linux"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end
