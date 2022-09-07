class Pdnsd < Formula
  desc "Proxy DNS server with permanent caching"
  # The upstream urls are currently down, so temporarily use an archived copy.
  homepage "https://web.archive.org/web/20201203080556/members.home.nl/p.a.rombouts/pdnsd/"
  url "https://web.archive.org/web/20200323100335/members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz"
  mirror "https://fossies.org/linux/misc/dns/pdnsd-1.2.9a-par.tar.gz"
  version "1.2.9a-par"
  sha256 "bb5835d0caa8c4b31679d6fd6a1a090b71bdf70950db3b1d0cea9cf9cb7e2a7b"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pdnsd"
    rebuild 3
    sha256 mojave: "fc19415fa3b8107805ad670af8944a5b27f36917710b55420ce65e4314671a92"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-cachedir=#{var}/cache/pdnsd"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This install of "pdnsd" expects config files to be in #{etc}
      All state files (status and cache) are stored in #{var}/cache/pdnsd.

      pdnsd needs to run as root since it listens on privileged ports.

      Sample config file can be found at #{etc}/pdnsd.conf.sample.

      Note that you must create the config file before starting the service,
      and change ownership to "root" or pdnsd will refuse to run:
        sudo chown root #{etc}/pdnsd.conf

      For other related utilities, e.g. pdnsd-ctl, to run, change the ownership
      to the user (default: nobody) running the service:
        sudo chown -R nobody #{var}/log/pdnsd.log #{var}/cache/pdnsd
    EOS
  end

  plist_options startup: true
  service do
    run opt_sbin/"pdnsd"
    keep_alive true
    error_log_path var/"log/pdnsd.log"
    log_path var/"log/pdnsd.log"
  end

  test do
    assert_match "version #{version}",
      shell_output("#{sbin}/pdnsd --version", 1)
  end
end
