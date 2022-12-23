class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.3.tar.gz"
  sha256 "941016c4564bca662080bb01aea74f06630bd665e598c6f6967fd91b2e2e0bb6"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/c-blosc"
    sha256 cellar: :any, mojave: "a055ea007ede67853bad246fd08d9bbeb01644628fc335813d548830c44e1f65"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
