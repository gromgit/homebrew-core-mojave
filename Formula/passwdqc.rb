class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-2.0.2.tar.gz"
  sha256 "ff1f505764c020f6a4484b1e0cc4fdbf2e3f71b522926d90b4709104ca0604ab"
  license "0BSD"
  revision 1

  livecheck do
    url :homepage
    regex(/href=["']?passwdqc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/passwdqc"
    sha256 cellar: :any, mojave: "5ebb25c4bd18deff7321754fc97cfce049e04ba9bd6ffcb01b5275d80587d91a"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    # https://github.com/openwall/passwdqc/issues/15
    inreplace "passwdqc_filter.h", "<endian.h>", "<machine/endian.h>" if OS.mac?

    args = %W[
      BINDIR=#{bin}
      CC=#{ENV.cc}
      CONFDIR=#{etc}
      DEVEL_LIBDIR=#{lib}
      INCLUDEDIR=#{include}
      MANDIR=#{man}
      PREFIX=#{prefix}
      SHARED_LIBDIR=#{lib}
    ]

    args << if OS.mac?
      "SECUREDIR_DARWIN=#{prefix}/pam"
    else
      "SECUREDIR=#{prefix}/pam"
    end

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
