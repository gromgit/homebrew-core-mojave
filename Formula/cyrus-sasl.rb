class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cyrus-sasl"
    rebuild 1
    sha256 mojave: "b1498b38f8afdd794cc8eb2615c86da9a14476f12c1764f4e1fbced7606db447"
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"

  def install
    system "./configure",
      "--disable-macos-framework",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sasl/saslutil.h>
      #include <assert.h>
      #include <stdio.h>
      int main(void) {
        char buf[123] = "\\0";
        unsigned len = 0;
        int ret = sasl_encode64("Hello, world!", 13, buf, sizeof buf, &len);
        assert(ret == SASL_OK);
        printf("%u %s", len, buf);
        return 0;
      }
    EOS

    system ENV.cxx, "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lsasl2"
    assert_equal "20 SGVsbG8sIHdvcmxkIQ==", shell_output("./test")
  end
end
