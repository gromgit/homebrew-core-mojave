class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.7.tar.gz"
  sha256 "fcb3f25e68081c54e5d560d6d1f6448d384a7051e9c56d56ee0d65d6d7954db1"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/primesieve"
    sha256 cellar: :any, mojave: "e5c8d63c798f54e5aeee81deca2725d479d344455cb12e8bd9960ab3a220651d"
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
