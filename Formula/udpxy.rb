class Udpxy < Formula
  desc "UDP-to-HTTP multicast traffic relay daemon"
  homepage "http://gigapxy.com/udpxy-en.html"
  url "http://gigapxy.com/download/1_23/udpxy.1.0.23-12-prod.tar.gz"
  mirror "https://fossies.org/linux/www/old/udpxy.1.0.23-12-prod.tar.gz"
  version "1.0.23-12"
  sha256 "16bdc8fb22f7659e0427e53567dc3e56900339da261199b3d00104d699f7e94c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0c2b4a23d90563036f55cce0df21dcd71f140dd34a69a9d88d1d6f0b811a1ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04a26cca83eb951ff7a220607e100f1ba760ff1bc6cc92e6a315b8eb2890a663"
    sha256 cellar: :any_skip_relocation, monterey:       "f19c646d2c3ca4bcecb3fec922690d2a82c985b78af52654ba32e656fa0fdc66"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d8d0bd1886d80ff73bc3b79988b09da3b2b16f00279f2eebad8c57dae24cdf"
    sha256 cellar: :any_skip_relocation, catalina:       "96010937851dc29d03c5cc24f8f5f06ec348ce598f2f8156ce53e7e6b5e69fa7"
    sha256 cellar: :any_skip_relocation, mojave:         "4688df2c4fd1ce7749d6d032f77cdae700129fa42284d9fc5ce1792ae9121151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd123b142b4fa0ceb6a8d078a307499332c0911634be090bce60dfd8cf42d7dd"
  end

  # As of writing, www.udpxy.com is a parked domain page (though gigapxy.com
  # hosts the same site). The homepage states, "development has been on hold
  # since 2012, with most of the effort routed toward enterprise-grade products,
  # such as Gigapxy, RoWAN, GigA+ and GigaTools." The udpxy `README` (last
  # modified 2018-01-18) has a "Project Status" section that states, "udpxy has
  # not been extended or supported for 4+ years, having been replaced by
  # Gigapxy - a superior enterprise-oriented product. Please see more info at
  # http://gigapxy.com, thank you."
  deprecate! date: "2022-05-03", because: :unsupported

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=''"
  end

  service do
    run [opt_bin/"udpxy", "-p", "4022"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end
end
