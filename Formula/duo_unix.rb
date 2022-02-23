class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.12.0.tar.gz"
  sha256 "a4479f893e036f38a5809d71ce47f69118f6ef61822cc1c66afccf143c5d71f8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://github.com/duosecurity/duo_unix.git"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duo_unix"
    sha256 mojave: "42535c17f6cf8178e35ccddfa55742ffef13c3da2cc2b77f089e0c8593f9235e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
