class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.8.tar.gz"
  sha256 "7a87a6fe7b1bd36a1ce277cf50e125ece7b2ed0236e252a66e2b34ca8f88b7f5"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpki-client"
    sha256 mojave: "df855345346f9bbb690d0e2ece436d7c658abade2773fa0b3f6c7058f8c53299"
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
