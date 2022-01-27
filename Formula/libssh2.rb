class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://www.libssh2.org/"
  url "https://www.libssh2.org/download/libssh2-1.10.0.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.10.0/libssh2-1.10.0.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.10.0.tar.gz"
  sha256 "2d64e90f3ded394b91d3a2e774ca203a4179f69aebee03003e5a6fa621e41d51"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libssh2"
    rebuild 1
    sha256 cellar: :any, mojave: "f7d2960282f53e3aeb23c3afd72348b325bc7442921750cc087a95c7d4f29b43"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
