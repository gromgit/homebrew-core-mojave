class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.10.1-source.zip"
  sha256 "2a6e602fd593e0a65d8d310c0952bbdfff34ef361362ae87b2a850b62d36f0b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/antlr4-cpp-runtime"
    sha256 cellar: :any, mojave: "fbd5ee8b6209461261605852e8e19ad1efba0cdb27f1dafc71bfecbc4694a823"
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
