class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.2/libjpeg-turbo-2.1.2.tar.gz"
  sha256 "09b96cb8cbff9ea556a9c2d173485fd19488844d55276ed4f42240e1e2073ce5"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpeg-turbo"
    rebuild 1
    sha256 mojave: "1a6f6e0cff191ac961464503b7fee9db5b58e12e2fd4158362d072852ab59b7b"
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
    system "cmake", ".", "-DWITH_JPEG8=1",
                         "-DCMAKE_INSTALL_LIBDIR=#{lib}",
                         *args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
