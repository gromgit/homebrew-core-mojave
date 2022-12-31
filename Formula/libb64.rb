class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.1.zip"
  sha256 "20106f0ba95cfd9c35a13c71206643e3fb3e46512df3e2efb2fdbf87116314b2"
  license "CC-PDDC"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libb64"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "3ee1cd100a68e4e8821bb6005305e1fafbba20eb6689cbb925a2631436f7d1f7"
  end

  def install
    system "make", "all_src"
    include.install "include/b64"
    lib.install "src/libb64.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <b64/cencode.h>
      int main()
      {
        base64_encodestate B64STATE;
        base64_init_encodestate(&B64STATE);
        char buf[32];
        int c = base64_encode_block("\x01\x02\x03\x04", 4, buf, &B64STATE);
        c += base64_encode_blockend(buf+c, &B64STATE);
        if (memcmp(buf,"AQIDBA==",8)) return(-1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lb64", "-o", "test"
    system "./test"
  end
end
