class Libsquish < Formula
  desc "Library for compressing images with the DXT standard"
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.15.tgz"
  sha256 "628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsquish"
    sha256 cellar: :any, mojave: "72db00ca3a9cdb8ef3710e3fde76b59b3426286f36a5177d98b632907680afa4"
  end

  depends_on "cmake" => :build

  def install
    # Static and shared libraries have to be built using separate calls to cmake.
    args = []
    args << "-DBUILD_SQUISH_WITH_SSE2=OFF" if Hardware::CPU.arm?
    system "cmake", "-S", ".", "-B", "build_static", *std_cmake_args, *args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libsquish.a"

    args << "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "-S", ".", "-B", "build_shared", *std_cmake_args, *args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include <squish.h>
      int main(void) {
        printf("%d", GetStorageRequirements(640, 480, squish::kDxt1));
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", "-L#{lib}", "-lsquish"
    assert_equal "153600", shell_output("./test")
  end
end
