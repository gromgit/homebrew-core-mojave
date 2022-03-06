class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.3/libjpeg-turbo-2.1.3.tar.gz"
  sha256 "467b310903832b033fe56cd37720d1b73a6a3bd0171dbf6ff0b620385f4f76d0"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpeg-turbo"
    rebuild 1
    sha256 cellar: :any, mojave: "16cd9eea3a283412316beeb8fd98b6d4241623f649bed173ce9a7db419bb1f63"
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
