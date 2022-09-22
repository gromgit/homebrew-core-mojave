class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.18.0.tar.gz"
  sha256 "01f4c5d97113d55d469b8078d1b2a8966ee1dfd231574322b36ec48c897c5ae9"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openfortivpn"
    sha256 mojave: "68231e30686cc0a9eced3965c38555260c7c1cf8816149388543c7ed757b2641"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  plist_options startup: true
  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
