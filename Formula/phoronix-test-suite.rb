class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.8.1.tar.gz"
  sha256 "d17ab231a2dadec506624db62d560565ada065671b290dc460cb8a757e98d96e"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/phoronix-test-suite"
    sha256 cellar: :any_skip_relocation, mojave: "cf2dd4e1198a7bb25435faeb3caa7ab7445b28cb4b11cec63720ea5b67cd71a5"
  end

  depends_on "php"

  def install
    ENV["DESTDIR"] = buildpath/"dest"
    system "./install-sh", prefix
    prefix.install (buildpath/"dest/#{prefix}").children
    bash_completion.install "dest/#{prefix}/../etc/bash_completion.d/phoronix-test-suite"
  end

  # 7.4.0 installed files in the formula's rack so clean up the mess.
  def post_install
    rm_rf [prefix/"../etc", prefix/"../usr"]
  end

  test do
    cd pkgshare if OS.mac?

    # Work around issue directly running command on Linux CI by using spawn.
    # Error is "Forked child process failed: pid ##### SIGKILL"
    require "pty"
    output = ""
    PTY.spawn(bin/"phoronix-test-suite", "version") do |r, _w, pid|
      sleep 2
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, output
  end
end
