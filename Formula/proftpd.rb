class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/v1.3.7e.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7e.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7e.tar.gz"
  version "1.3.7e"
  sha256 "6e716a3b53ee069290399fce6dccf4c229fafe6ec2cb14db3778b7aa3f9a8c92"
  license "GPL-2.0-or-later"

  # Proftpd uses an incrementing letter after the numeric version for
  # maintenance releases. Versions like `1.2.3a` and `1.2.3b` are not alpha and
  # beta respectively. Prerelease versions use a format like `1.2.3rc1`.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proftpd"
    rebuild 1
    sha256 mojave: "0e849aa9478982ab071cb5ec2777902dde3c99ab0c0284794a517ea929f0d7e6"
  end

  uses_from_macos "libxcrypt"

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = Utils.safe_popen_read("groups").split.first
    system "make", "INSTALL_USER=#{install_user}", "INSTALL_GROUP=#{install_group}", "install"
  end

  service do
    run [opt_sbin/"proftpd"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match version.to_s, shell_output("#{opt_sbin}/proftpd -v")
  end
end
