class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.2/libjpeg-turbo-2.1.2.tar.gz"
  sha256 "09b96cb8cbff9ea556a9c2d173485fd19488844d55276ed4f42240e1e2073ce5"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpeg-turbo"
    rebuild 2
    sha256 mojave: "341b15b76d56da56a0f0ae467bc8b55143a5993a330f0239e2e9a4afbd7a048d"
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
