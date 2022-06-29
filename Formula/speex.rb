class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.1.tar.gz"
  sha256 "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(/href=.*?speex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/speex"
    sha256 cellar: :any, mojave: "31e8d80f363ae97e323f5b7a755af4765b357db83ef59c9465a1a5bc6807388b"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    ENV.deparallelize
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <speex/speex.h>

      int main()
      {
          SpeexBits bits;
          void *enc_state;

          speex_bits_init(&bits);
          enc_state = speex_encoder_init(&speex_nb_mode);

          speex_bits_destroy(&bits);
          speex_encoder_destroy(enc_state);

          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspeex", "-o", "test"
    system "./test"
  end
end
