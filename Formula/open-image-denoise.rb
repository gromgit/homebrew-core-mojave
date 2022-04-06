class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.3/oidn-1.4.3.src.tar.gz"
  sha256 "3276e252297ebad67a999298d8f0c30cfb221e166b166ae5c955d88b94ad062a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/open-image-denoise"
    rebuild 1
    sha256 cellar: :any, mojave: "b42aa684f11d363a9f989c56127f12389ad75533e54db3f44432aa9e796e8216"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
    # Fix arm64 build targeting iOS
    inreplace "cmake/oidn_ispc.cmake", 'set(ISPC_TARGET_OS "--target-os=ios")', ""

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <OpenImageDenoise/oidn.h>
      int main() {
        OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
        oidnCommitDevice(device);
        return oidnGetDeviceError(device, 0);
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lOpenImageDenoise"
    system "./a.out"
  end
end
