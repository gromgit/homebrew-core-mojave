class Libretls < Formula
  desc "Libtls for OpenSSL"
  homepage "https://git.causal.agency/libretls/about/"
  url "https://causal.agency/libretls/libretls-3.5.2.tar.gz"
  sha256 "59ce9961cb1b1a2859cacb9863eeccc3bbeadf014840a1c61a0ac12ad31bcc9e"
  license "ISC"

  livecheck do
    url "https://causal.agency/libretls/"
    regex(/href=.*?libretls[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libretls"
    sha256 cellar: :any_skip_relocation, mojave: "65a399d1d4cc1191d6ade011df8d2e41ddf7a0cc74408aafd38f955f78a8f60a"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tls.h>
      int main() {
        return tls_init();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltls"
    system "./test"
  end
end
