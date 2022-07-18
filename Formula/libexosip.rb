class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.3.0.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/exosip/libexosip2-5.3.0.tar.gz"
  sha256 "5b7823986431ea5cedc9f095d6964ace966f093b2ae7d0b08404788bfcebc9c2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/exosip/"
    regex(/href=.*?libexosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libexosip"
    rebuild 2
    sha256 cellar: :any, mojave: "1a3b324a3963cc7d45b15cac9b6fbb5f858cbd673882036a13c8a6c5088cb36a"
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl@1.1"

  def install
    # Extra linker flags are needed to build this on macOS. See:
    # https://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    if OS.mac?
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices " \
                            "-framework Security"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netinet/in.h>
      #include <eXosip2/eXosip.h>

      int main() {
          struct eXosip_t *ctx;
          int i;
          int port = 35060;

          ctx = eXosip_malloc();
          if (ctx == NULL)
              return -1;

          i = eXosip_init(ctx);
          if (i != 0)
              return -1;

          i = eXosip_listen_addr(ctx, IPPROTO_UDP, NULL, port, AF_INET, 0);
          if (i != 0) {
              eXosip_quit(ctx);
              fprintf(stderr, "could not initialize transport layer\\n");
              return -1;
          }

          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-leXosip2", "-o", "test"
    system "./test"
  end
end
