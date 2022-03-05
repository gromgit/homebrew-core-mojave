class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  license "BSD-3-Clause"
  revision 12

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flann"
    rebuild 1
    sha256 cellar: :any, mojave: "2e541fd95239510ef0bf20a627d1ca132db1089d037a3c2354bbe107060099b8"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    # Fix for Linux build: https://bugs.gentoo.org/652594
    # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
    patch do
      url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
      sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
    end
  end

  resource("dataset") do
    url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
    sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
