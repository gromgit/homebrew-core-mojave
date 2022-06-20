class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.12.1.tar.gz"
  sha256 "bcba8eac949c983955eadcd63199a327add3b8f00aa6e7eb87cd7f4e28b2115b"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duo_unix"
    sha256 mojave: "4f983b852a0539c0733c53fe454c841f7ed803674d0727b48a07ea86a0238fb8"
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
