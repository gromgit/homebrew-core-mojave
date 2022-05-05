class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://github.com/technion/libscrypt"
  url "https://github.com/technion/libscrypt/archive/v1.22.tar.gz"
  sha256 "a2d30ea16e6d288772791de68be56153965fe4fd4bcd787777618b8048708936"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libscrypt"
    sha256 cellar: :any, mojave: "b97f2e9f143be926089659df2f392afbb7273942b8d7a1386b026b80e0f5287c"
  end

  def install
    if OS.mac?
      system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "LDFLAGS_EXTRA=", "CFLAGS_EXTRA="
      system "make", "check", "LDFLAGS=", "LDFLAGS_EXTRA=", "CFLAGS_EXTRA="
    else
      system "make"
      system "make", "check"
      lib.install "libscrypt.a", "libscrypt.so", "libscrypt.so.0"
      include.install "libscrypt.h"
      prefix.install "libscrypt.version"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libscrypt.h>
      int main(void) {
        char buf[SCRYPT_MCF_LEN];
        libscrypt_hash(buf, "Hello, Homebrew!", SCRYPT_N, SCRYPT_r, SCRYPT_p);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lscrypt", "-o", "test"
    system "./test"
  end
end
