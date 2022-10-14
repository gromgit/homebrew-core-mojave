class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.1.tar.gz"
  sha256 "7ca6af7dc2e3e054de9e17b9dfd88609a7fd202812b1c216f43cc41647c97311"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/highway"
    sha256 cellar: :any_skip_relocation, mojave: "a10b451ae2a4fdd3c1f9ca626b061221416b4717f67b2f15abbffcce73275bce"
  end

  depends_on "cmake" => :build

  # These used to be bundled with `jpeg-xl`.
  link_overwrite "include/hwy/*", "lib/pkgconfig/libhwy*"

  # Fix missing missing exec_prefix variable in libhwy_test.pc.
  # Remove with the next release.
  patch do
    url "https://github.com/google/highway/commit/357e21beabb1af037f20130b4195fa5d0e6bbbfb.patch?full_index=1"
    sha256 "35ae4d7cd0cdaaca83c5b6da01b9c19f34c3f293b6892f3c3afdb202255f523a"
  end

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHWY_ENABLE_TESTS=OFF",
                    "-DHWY_ENABLE_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
    (share/"hwy").install "hwy/examples"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{share}", "-I#{include}",
                    share/"hwy/examples/benchmark.cc", "-L#{lib}", "-lhwy"
    system "./a.out"
  end
end
