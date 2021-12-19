class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.3.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.3.0.tar.gz"
  sha256 "f4725916c22cf514969efb15c3c207233d64739383f7d42956038b78f6cae8c8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libosip"
    sha256 cellar: :any, mojave: "b86ee45cd719d8131cafb5513db0d53503ee6b9ed4d3e99a1c804144b69a9f47"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
