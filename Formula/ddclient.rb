class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  license "GPL-2.0-or-later"
  revision 1

  # Remove `stable` block when resources are no longer needed.
  stable do
    url "https://github.com/ddclient/ddclient/archive/v3.9.1.tar.gz"
    sha256 "e4969e15cc491fc52bdcd649d4c2b0e4b1bf0c9f9dba23471c634871acc52470"

    on_linux do
      # Dependency of Data::Validate::IP. Remove at next release.
      resource "NetAddr::IP" do
        url "https://cpan.metacpan.org/authors/id/M/MI/MIKER/NetAddr-IP-4.079.tar.gz"
        sha256 "ec5a82dfb7028bcd28bb3d569f95d87dd4166cc19867f2184ed3a59f6d6ca0e7"
      end
    end

    # TODO: Remove in next release. See:
    # https://github.com/ddclient/ddclient/blob/v3.10.0_1/ChangeLog.md#compatibility-and-dependency-changes
    resource "Data::Validate::IP" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Data-Validate-IP-0.27.tar.gz"
      sha256 "e1aa92235dcb9c6fd9b6c8cda184d1af73537cc77f4f83a0f88207a8bfbfb7d6"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ddclient"
    sha256 cellar: :any_skip_relocation, mojave: "9486932244cad385337ebe7322c54a0ae3bfdbeacdda8c52bbcdbfa41eb59050"
  end

  head do
    url "https://github.com/ddclient/ddclient.git", branch: "develop"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5" if resources.present?

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    if build.head?
      system "./autogen"
      system "./configure", *std_configure_args, "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl"
      system "make", "install", "CURL=curl"
    else
      # Adjust default paths in script
      inreplace "ddclient" do |s|
        s.gsub! "/etc/ddclient", "#{etc}/ddclient"
        s.gsub! "/var/cache/ddclient", "#{var}/run/ddclient"
      end

      sbin.install "ddclient"
      sbin.env_script_all_files(libexec/"sbin", PERL5LIB: ENV["PERL5LIB"])
    end

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient", "#{etc}/ddclient"
    inreplace "sample-etc_cron.d_ddclient", %r{/usr/s?bin/ddclient}, "#{sbin}/ddclient"
    inreplace "sample-etc_ddclient.conf", "/var/run/ddclient.pid", "#{var}/run/ddclient/pid"

    doc.install %w[
      sample-ddclient-wrapper.sh
      sample-etc_cron.d_ddclient
      sample-etc_ddclient.conf
    ]
  end

  def post_install
    (etc/"ddclient").mkpath
    (var/"run/ddclient").mkpath
  end

  def caveats
    <<~EOS
      For ddclient to work, you will need to create a configuration file
      in #{etc}/ddclient. A sample configuration can be found in
      #{opt_share}/doc/ddclient.

      Note: don't enable daemon mode in the configuration file; see
      additional information below.

      The next reboot of the system will automatically start ddclient.

      You can adjust the execution interval by changing the value of
      StartInterval (in seconds) in /Library/LaunchDaemons/#{plist_path.basename}.
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"ddclient", "-file", etc/"ddclient/ddclient.conf"]
    run_type :interval
    interval 300
    working_dir etc/"ddclient"
  end

  test do
    begin
      pid = fork do
        exec sbin/"ddclient", "-file", doc/"sample-etc_ddclient.conf", "-debug", "-verbose", "-noquiet"
      end
      sleep 1
    ensure
      Process.kill "TERM", pid
      Process.wait
    end
    $CHILD_STATUS.success?
  end
end
