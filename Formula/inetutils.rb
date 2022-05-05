class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.2.tar.xz"
  sha256 "d547f69172df73afef691a0f7886280fd781acea28def4ff4b4b212086a89d80"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inetutils"
    sha256 mojave: "b4f672f134c14fba4fe810feeea04daa5856f6a7dbaa37b7074126639492b0b7"
  end

  depends_on "libidn2"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  conflicts_with "telnet", because: "both install `telnet` binaries"
  conflicts_with "tnftp", because: "both install `ftp` binaries"

  def noshadow
    # List of binaries that do not shadow macOS utils
    list = %w[dnsdomainname rcp rexec rlogin rsh]
    list += %w[ftp telnet] if MacOS.version >= :high_sierra
    list
  end

  def linux_conflicts
    # List of binaries that conflict with other common implementations
    list = %w[dnsdomainname hostname ifconfig] # net-tools
    list << "logger" # util-linux
    list << "ping" # iputils
    list << "whois" # whois
    list
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-idn",
                          "--program-prefix=g"
    system "make", "SUIDMODE=", "install"

    no_conflict = OS.mac? ? noshadow : []

    # Symlink server commands without 'g' prefix into sbin on Linux.
    # (ftpd, inetd, rexecd, rlogind, rshd, syslogd, talkd, telnetd, tftpd, uucpd)
    if OS.linux?
      libexec.find.each do |path|
        next if !File.executable?(path) || File.directory?(path)

        cmd = path.basename.to_s.sub(/^g/, "")
        sbin.install_symlink libexec/"g#{cmd}" => cmd
        man8.install_symlink man8/"g#{cmd}.8" => "#{cmd}.8"
      end
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next if !File.executable?(path) || File.directory?(path)

      cmd = path.basename.to_s.sub(/^g/, "")
      no_conflict << cmd unless OS.mac?
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
    end
    libexec.install_symlink "gnuman" => "man"

    no_conflict -= linux_conflicts if OS.linux?
    # Symlink binaries that are not shadowing macOS utils or are
    # non-conflicting with common alternatives on Linux.
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    s = ""
    on_macos do
      s += <<~EOS
        Only the following commands have been installed without the prefix 'g'.

            #{noshadow.sort.join("\n    ")}

        If you really need to use other commands with their normal names,
      EOS
    end
    on_linux do
      s += <<~EOS
        The following commands have been installed with the prefix 'g'.

            #{linux_conflicts.sort.join("\n    ")}

        If you really need to use these commands with their normal names,
      EOS
    end
    s += <<~EOS
      you can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
    s
  end

  test do
    ftp = OS.mac? ? libexec/"gnubin/ftp" : bin/"ftp"
    output = pipe_output("#{ftp} -v", "open ftp.gnu.org\nanonymous\nls\nquit\n")
    assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
  end
end
