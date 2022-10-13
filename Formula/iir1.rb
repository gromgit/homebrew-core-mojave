class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.3.tar.gz"
  sha256 "de241ef7a3e5ae8e1309846fe820a2e18978aa3df3922bd83c2d75a0fcf4e78f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iir1"
    sha256 cellar: :any, mojave: "9133324d38a75f6e89c1ab078a0ca7d95dda75c99f8d5cfa3f849ee3906232c2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/butterworth.cpp", "test/assert_print.h"
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
