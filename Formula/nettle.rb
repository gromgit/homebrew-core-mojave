class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.8.1.tar.gz"
  sha256 "364f3e2b77cd7dcde83fd7c45219c834e54b0c75e428b6f894a23d12dd41cbfe"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nettle"
    rebuild 3
    sha256 cellar: :any, mojave: "4db28198856e59b61661b721979fe911cf495e1e1ccbc0c80a5a39f8f7833177"
  end

  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnettle", "-o", "test"
    system "./test"
  end
end
