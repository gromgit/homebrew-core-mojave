class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  license "GPL-2.0"
  head "https://github.com/bitlbee/bitlbee.git", branch: "master"

  stable do
    url "https://get.bitlbee.org/src/bitlbee-3.6.tar.gz"
    sha256 "9f15de46f29b46bf1e39fc50bdf4515e71b17f551f3955094c5da792d962107e"
  end

  livecheck do
    url "https://get.bitlbee.org/src/"
    regex(/href=.*?bitlbee[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bitlbee"
    rebuild 1
    sha256 mojave: "87758a0e1bd92c1540b3fbd20343f971a35e118694d4163f4b0922ff6fc7696a"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    args = %W[
      --prefix=#{prefix}
      --plugindir=#{HOMEBREW_PREFIX}/lib/bitlbee/
      --debug=0
      --ssl=gnutls
      --etcdir=#{etc}/bitlbee
      --pidfile=#{var}/bitlbee/run/bitlbee.pid
      --config=#{var}/bitlbee/lib/
      --ipsocket=#{var}/bitlbee/run/bitlbee.sock
    ]

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make", "install"
    # Install the dev headers too
    system "make", "install-dev"
    # This build has an extra step.
    system "make", "install-etc"
  end

  def post_install
    (var/"bitlbee/run").mkpath
    (var/"bitlbee/lib").mkpath
  end

  service do
    run opt_sbin/"bitlbee"
    sockets "tcp://127.0.0.1:6667"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/bitlbee -V", 1)
  end
end
