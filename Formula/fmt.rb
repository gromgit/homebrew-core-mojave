class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/8.1.1.tar.gz"
  sha256 "3d794d3cf67633b34b2771eb9f073bde87e846e0d395d254df7b211ef1ec7346"
  license "MIT"
  revision 1
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fmt"
    sha256 cellar: :any, mojave: "724b9bedd41070b83aab669150b5d76ecef3c5f4629f67bd39a3030d47fac431"
  end

  depends_on "cmake" => :build

  # Fix Watchman build.
  # https://github.com/fmtlib/fmt/issues/2717
  patch do
    url "https://github.com/fmtlib/fmt/commit/8f8a1a02d5c5cb967d240feee3ffac00d66f22a2.patch?full_index=1"
    sha256 "ac5d7a8f9eabd40e34f21b1e0034fbc4147008f13b7bf2314131239fb3a7bdab"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
