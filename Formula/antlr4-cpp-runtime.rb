class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9.3-source.zip"
  sha256 "5f0af6efd81f476c3e775c486eb0a71c25d6bbc14373e88a64690e2738d68e03"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/antlr4-cpp-runtime"
    rebuild 2
    sha256 cellar: :any, mojave: "2d5c846842821224d4292a5767c98f51a7fa737a5c49d088c4dba8efb9f2a93a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end
