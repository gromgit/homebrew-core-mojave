class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.1/arrayfire-full-3.8.1.tar.bz2"
  sha256 "13edaeb329826e7ca51b5db2d39b8dbdb9edffb6f5b88aef375e115443155668"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arrayfire"
    rebuild 1
    sha256 cellar: :any, mojave: "cd4810c0c213a85758533dd80c0ee3e68186df90be2c9b49a47c7da8b1fcdf19"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    if OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{Formula["fftw"].opt_lib.relative_path_from(lib)}"
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{Formula["openblas"].opt_lib.relative_path_from(lib)}"
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{(HOMEBREW_PREFIX/"lib").relative_path_from(lib)}"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
