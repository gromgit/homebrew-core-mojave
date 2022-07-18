class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.9.tar.gz"
  sha256 "accf531c885a9d95a37a6627399a59b360fa29a11810aba15b27d7526ce43e75"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpki-client"
    sha256 mojave: "4ae8baa6889792514e3f588f44ecd98e563ac475a91858c14893d345da7064a9"
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
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1").lines.last
  end
end
