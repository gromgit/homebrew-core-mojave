class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.1.tar.gz"
  sha256 "465ff764f437ffcfa7cad8d3a4098a781d3919f754483fdf406a642156af2540"
  license :cannot_represent

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libimagequant"
    sha256 cellar: :any, mojave: "152f93d3ea1aa1a095c07f4e4f35ae1f1be0843a358c9790456416cf185a91b8"
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
