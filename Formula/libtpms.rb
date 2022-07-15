class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "9522c69001e46a3b0e1ccd646d36db611b2366c395099d29037f2b067bf1bc60"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtpms"
    sha256 cellar: :any, mojave: "0139df86fd6798c4f965b2ca5254b8a6646e8772c913aedd56a982def511cdf2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh", *std_configure_args, "--with-openssl", "--with-tpm2"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtpms/tpm_library.h>

      int main()
      {
          TPM_RESULT res = TPMLIB_ChooseTPMVersion(TPMLIB_TPM_VERSION_2);
          if (res) {
              TPMLIB_Terminate();
              return 1;
          }
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltpms", "-o", "test"
    system "./test"
  end
end
