class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v7.3.tar.gz"
  sha256 "471fe21461e42e5f28404e17ff840fb527b3ec4064853253ee22cf4a81656332"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/primecount"
    sha256 cellar: :any, mojave: "14a2ed82cf7b076787ca8a13da257725d1c131c7e91916d3f94588c7d8de1ec0"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "primesieve"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
