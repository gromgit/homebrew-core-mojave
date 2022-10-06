class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 4

  stable do
    url "https://collectd.org/files/collectd-5.12.0.tar.bz2"
    sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://collectd.org/download.shtml"
    regex(/href=.*?collectd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/collectd"
    sha256 mojave: "be9389eaa3e0071c52d22fbbb9f1919bc4d69d34ac5d88b7123b61e2a1cbbe67"
  end

  head do
    url "https://github.com/collectd/collectd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  def install
    args = std_configure_args + %W[
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]
    args << "--with-perl-bindings=PREFIX=#{prefix} INSTALLSITEMAN3DIR=#{man3}" if OS.linux?

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"collectd", "-f", "-C", etc/"collectd.conf"]
    keep_alive true
    error_log_path var/"log/collectd.log"
    log_path var/"log/collectd.log"
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
