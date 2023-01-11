class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.10.0/inadyn-2.10.0.tar.xz"
  sha256 "58ca61afdc0554b63b3eba1265caa1049c783d0ccfdbabc98273266466d8f142"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inadyn"
    sha256 mojave: "bfe7ab2508b226e22621abd6e8f489f5a841d9f474a7a7540295025ef20bae93"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
