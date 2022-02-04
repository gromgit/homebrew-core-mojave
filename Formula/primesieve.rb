class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.8.tar.gz"
  sha256 "0cd0490259e6e919c6e3dd3f3e69ac6d91e6cbe616e22a219abe4006d9293d5d"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/primesieve"
    sha256 cellar: :any, mojave: "fb3f1f4d0372c913cdeed1075d5723f188e0a64021f7ed41e30a2d301078c096"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
