class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.28/pkcs11-helper-1.28.0.tar.bz2"
  sha256 "5bd55adafdbb708e096070dd0a910f23e1d5fd6291922398c1a15f00fff2b5ec"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pkcs11-helper"
    sha256 cellar: :any, mojave: "1e4b718387ea82e7f419e89e6be02372ddf0dd665aae879cecebbbdc90dd9905"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <pkcs11-helper-1.0/pkcs11h-core.h>

      int main() {
        printf("Version: %08x", pkcs11h_getVersion ());
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}",
                   "-lpkcs11-helper", "-o", "test"
    system "./test"
  end
end
