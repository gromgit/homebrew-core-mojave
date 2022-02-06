class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.0.tar.gz"
  sha256 "d041f6f2dac36df76f22cedaf74c914f46bff1fea7d6025d1b13199204c25dd8"
  license :cannot_represent

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libimagequant"
    sha256 cellar: :any, mojave: "86d46171369b192d393b7593918577baac027bc4df29c91f5e7f1397ee3e49ee"
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
