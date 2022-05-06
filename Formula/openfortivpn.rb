class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.17.2.tar.gz"
  sha256 "0f3f3c767cb8bf81418a0fc7c6ab7636c574840c3b6a95c50901c3e1a09c079a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openfortivpn"
    rebuild 1
    sha256 mojave: "675ee05c3ee5f7bac11077bde9acb03e63da95c4b6541d38fdf9b20a7ec86091"
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
