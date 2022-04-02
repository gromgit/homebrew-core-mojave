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
    sha256 mojave: "37c6002ee954a81c3e7edeaed1662748fe113fa833485204bffb3bcec263e6d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}", "--with-gpgme", "--sysconfdir=#{etc}",
                          "--with-gpg=#{Formula["gnupg"].opt_bin}/gpg"
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
