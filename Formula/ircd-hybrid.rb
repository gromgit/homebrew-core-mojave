class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.42/ircd-hybrid-8.2.42.tgz"
  sha256 "692d217bfc7ea37c4e4391fb86b0a92780bc32eb144f69623349721755b81f6a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ircd-hybrid"
    sha256 mojave: "57f47eeb56524d4880a87be63b25d315b303861085758f021f43bfbafba225a1"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  service do
    run opt_bin/"ircd"
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end
