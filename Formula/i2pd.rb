class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.41.0.tar.gz"
  sha256 "7b333cd26670903ef0672cf87aa9f895814ce2bbef2e587e69d66ad9427664e6"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/i2pd"
    sha256 cellar: :any, mojave: "c5fb5077b2adf59239b5d4d337eb78554b5faaa72b80aabe78a14d1600bfe2f9"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  # apply commit 5c15a12116c1e4447b94fd0f36caecfd2e5a40de to fix mutex lock on stop
  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/5c15a12116c1e4447b94fd0f36caecfd2e5a40de.patch?full_index=1"
    sha256 "bc3b1234966bd7d7dd13dcc71fd72f8db316b865aa7fb4e7bffa4fdd2efa4eb9"
  end

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
    ]

    args << "USE_AESNI=no" if Hardware::CPU.arm?

    system "make", "install", *args

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf",
                              etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  service do
    run [opt_bin/"i2pd", "--datadir=#{var}/lib/i2pd", "--conf=#{etc}/i2pd/i2pd.conf",
         "--tunconf=#{etc}/i2pd/tunnels.conf", "--log=file", "--logfile=#{var}/log/i2pd/i2pd.log",
         "--pidfile=#{var}/run/i2pd.pid"]
  end

  test do
    pidfile = testpath/"i2pd.pid"
    system bin/"i2pd", "--datadir=#{testpath}", "--pidfile=#{pidfile}", "--daemon"
    sleep 5
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    Process.kill "TERM", pid
  end
end
