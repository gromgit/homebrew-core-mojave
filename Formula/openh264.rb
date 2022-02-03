class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.2.0.tar.gz"
  sha256 "e4e5c8ba48e64ba6ce61e8b6e2b76b2d870c74c270147649082feabb40f25905"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openh264"
    sha256 cellar: :any, mojave: "1aab1c02f1e3440c2fdbc0283832b487ca95682ba0d62cccdf3733880f96de0c"
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end
