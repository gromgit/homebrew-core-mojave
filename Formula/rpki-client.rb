class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.6.tar.gz"
  sha256 "d147bbedd1eea0fac3a431144f836074588949c67e7ef6fdd94ecec37b762b6b"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpki-client"
    sha256 mojave: "7df80b3f94eb7c3fc8f780440884143eafd51c69abcab332f36455c76f492ac2"
  end

  depends_on "pkg-config" => :build
  depends_on "libressl"
  depends_on :macos

  def install
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "parse file ta/", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1").lines.last
  end
end
