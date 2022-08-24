class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d1c38c0492257c61fb60c85238d500c05184fd8e9e68fecba9cf304ff2d8726d"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libharu"
    sha256 cellar: :any_skip_relocation, mojave: "ab13f614cdb580a8b85679ed193818942cd0952ae2157809567cf4481ad44b57"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  uses_from_macos "zlib"

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build-static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libharu.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lharu", "-lz", "-lm", "-o", "test"
    system "./test"
  end
end
