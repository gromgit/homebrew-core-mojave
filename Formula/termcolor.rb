class Termcolor < Formula
  desc "Header-only C++ library for printing colored messages"
  homepage "https://termcolor.readthedocs.io/"
  url "https://github.com/ikalnytskyi/termcolor/archive/v2.1.0.tar.gz"
  sha256 "435994c32557674469404cb1527c283fdcf45746f7df75fd2996bb200d6a759f"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/termcolor"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8dbd5a2916e763954c5dc87501aa18b28229865d7d7653445fafb22353a18740"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <termcolor/termcolor.hpp>
      int main(int /*argc*/, char** /*argv*/)
      {
        std::cout << termcolor::red << "Hello Colorful World";
        std::cout << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match "Hello Colorful World", shell_output("./test")
  end
end
