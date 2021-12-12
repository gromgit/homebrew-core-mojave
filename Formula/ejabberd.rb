class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://static.process-one.net/ejabberd/downloads/21.12/ejabberd-21.12.tgz"
  sha256 "b6e6739947d3678525b14ee280cedb1a04280c83ea17a4741795aac99fbdad47"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.process-one.net/en/ejabberd/downloads/"
    regex(/href=.*?ejabberd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ejabberd"
    sha256 cellar: :any, mojave: "c073d4fa187b6ed123e74d33abd92f18f1ed3de41011c399216c7abd06f6597c"
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "erlang@22"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  conflicts_with "couchdb", because: "both install `jiffy` lib"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam"]

    system "./autogen.sh" if build.head?
    system "./configure", *args

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=clang -E"

    ENV.deparallelize
    system "make", "install"

    (etc/"ejabberd").mkpath
  end

  def post_install
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath

    # Create the vm.args file, if it does not exist. Put a random cookie in it to secure the instance.
    vm_args_file = etc/"ejabberd/vm.args"
    unless vm_args_file.exist?
      require "securerandom"
      cookie = SecureRandom.hex
      vm_args_file.write <<~EOS
        -setcookie #{cookie}
      EOS
    end
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>HOME</key>
          <string>#{var}/lib/ejabberd</string>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/ejabberdctl</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/lib/ejabberd</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"ejabberdctl", "ping"
  end
end
