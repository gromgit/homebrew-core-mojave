class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.4.tar.bz2"
  sha256 "ea849c83a72454e3ed4267697e8ca03390aee972ab421e7df69dfe42b65caaf7"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgcrypt"
    rebuild 1
    sha256 cellar: :any, mojave: "1db4904cff78ce69d1ce97073938a66f5b180b09fb137683b7034d9f4b239368"
  end

  depends_on "libgpg-error"

  # libgcrypt's libtool.m4 doesn't properly support macOS >= 11.x (see
  # libtool.rb formula). This causes the library to be linked with a flat
  # namespace which might cause issues when dynamically loading the library with
  # dlopen under some modes, see:
  #
  #  https://lists.gnupg.org/pipermail/gcrypt-devel/2021-September/005176.html
  #
  # We patch `configure` directly so we don't need additional build dependencies
  # (e.g. autoconf, automake, libtool)
  #
  # This patch has been applied upstream so it can be removed in the next
  # release.
  #
  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commit;h=c9cebf3d1824d6ec90fd864a744bb81c97ac7d31
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "make", "-C", "random", "rndjent.o", "rndjent.lo" }

    # Parallel builds work, but only when run as separate steps
    system "make"
    MachO.codesign!("#{buildpath}/tests/.libs/random") if OS.mac? && Hardware::CPU.arm?

    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
