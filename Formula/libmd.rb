class Libmd < Formula
  desc "BSD Message Digest library"
  homepage "https://www.hadrons.org/software/libmd/"
  url "https://libbsd.freedesktop.org/releases/libmd-1.0.4.tar.xz"
  sha256 "f51c921042e34beddeded4b75557656559cf5b1f2448033b4c1eec11c07e530f"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libmd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmd"
    rebuild 2
    sha256 cellar: :any, mojave: "d2e8a49bbd46df681d64df47882573e636726d7f74dfabba47651e1a2edb3e97"
  end

  # build patch, https://github.com/macports/macports-ports/blob/master/devel/libmd/files/patch-symbol-alias.diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62ea945/libmd/patch-symbol-alias.diff"
    sha256 "a9bb67cbc2243d12fe81b6c9f998dddbe2f58f11570749f98ee23b07d9a02d53"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>
      #include <md5.h>

      int main() {
          MD5_CTX ctx;
          uint8_t results[MD5_DIGEST_LENGTH];
          char *buf;
          buf = "abc";
          int n;
          n = strlen(buf);
          MD5Init(&ctx);
          MD5Update(&ctx, (uint8_t *)buf, n);
          MD5Final(results, &ctx);
          for (n = 0; n < MD5_DIGEST_LENGTH; n++)
              printf("%02x", results[n]);
          putchar('\\n');
          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmd", "-o", "test"
    assert_equal "900150983cd24fb0d6963f7d28e17f72", shell_output("./test").chomp
  end
end
