class Libtpms < Formula
  desc "Library for software emulation of a Trusted Platform Module"
  homepage "https://github.com/stefanberger/libtpms"
  url "https://github.com/stefanberger/libtpms/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "61d6f947a60686ec98e7cc5861f0999bd6cdaa1fc2b8901b8dc68d1a715b35cf"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtpms"
    sha256 cellar: :any, mojave: "12acdc65da7afa7e4ee2d9df31279ef3db1107f79a3d584da54b1561a667f014"
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
