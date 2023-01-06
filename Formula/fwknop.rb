class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.10.tar.gz"
  sha256 "a7c465ba84261f32c6468c99d5512f1111e1bf4701477f75b024bf60b3e4d235"
  license "GPL-2.0-or-later"
  head "https://github.com/mrash/fwknop.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fwknop"
    rebuild 1
    sha256 mojave: "56daff6f91001db3b0df6f0f4101da7a3fc50b4770fab61d8f36d6404d877476"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gpgme"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "iptables"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # fwknop-config_init.o:(.bss+0x4): multiple definition of `log_level_t'
    # Issue ref: https://github.com/mrash/fwknop/issues/305
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Fix failure with texinfo while building documentation.
    inreplace "doc/libfko.texi", "@setcontentsaftertitlepage", "" unless OS.mac?

    system "./autogen.sh"
    args = *std_configure_args + %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --with-gpgme
      --with-gpg=#{Formula["gnupg"].opt_bin}/gpg
    ]
    args << "--with-iptables=#{Formula["iptables"].opt_prefix}" unless OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
