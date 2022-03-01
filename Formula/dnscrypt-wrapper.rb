class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/v0.4.2.tar.gz"
  sha256 "911856dc4e211f906ca798fcf84f5b62be7fdbf73c53e5715ce18d553814ac86"
  license "ISC"
  revision 1
  head "https://github.com/Cofyc/dnscrypt-wrapper.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnscrypt-wrapper"
    rebuild 1
    sha256 cellar: :any, mojave: "a07f842bfdf16299f7f1fb258223847f3a86c915c5fb017ac1669c5e7e009b9b"
  end


  depends_on "autoconf" => :build
  depends_on "libevent"
  depends_on "libsodium"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair",
           "--provider-name=2.dnscrypt-cert.example.com",
           "--ext-address=192.168.1.1"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
