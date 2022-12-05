class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.4.tar.gz"
  sha256 "d121bbfb380a54aca8ea9d973c2e63afcbc1db67db46ea6bc63eeba44d7937c8"
  license :cannot_represent

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libimagequant"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f9e995df0deaaacc1cadd57f592cb2aae4502b6d667f0989ebba7f850dd886c0"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--prefix", prefix
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
