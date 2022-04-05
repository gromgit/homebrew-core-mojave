class Mbelib < Formula
  desc "P25 Phase 1 and ProVoice vocoder"
  homepage "https://github.com/szechyjs/mbelib"
  url "https://github.com/szechyjs/mbelib/archive/v1.3.0.tar.gz"
  sha256 "5a2d5ca37cef3b6deddd5ce8c73918f27936c50eb0e63b27e4b4fc493310518d"
  license "ISC"
  head "https://github.com/szechyjs/mbelib.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mbelib"
    rebuild 1
    sha256 cellar: :any, mojave: "28bdc2910806932834e04ae3228330d8da0d4a2abde54106617603ddf55b816d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"mb.cpp").write <<~EOS
      extern "C" {
      #include "mbelib.h"
      }
      int main() {
        float float_buf[160] = {1.23f, -1.12f, 4680.412f, 4800.12f, -4700.74f};
        mbe_synthesizeSilencef(float_buf);
        return (float_buf[0] != 0);
      }
    EOS
    system ENV.cxx, "mb.cpp", "-o", "test", "-L#{lib}", "-lmbe"
    system "./test"
  end
end
