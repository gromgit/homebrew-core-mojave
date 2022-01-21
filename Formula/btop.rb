class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "59a87b9d0bb0f5010d53f0ac72ddee9fd7b5a4039bce51b94b262313e946df02"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/btop"
    sha256 cellar: :any, mojave: "054cf00ea12bc6f7ee9513ce98bde13cf0a029f656ac768bbaf7a52c91294a76"
  end

  depends_on "coreutils" => :build
  depends_on "gcc"

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s
  # GCC 10 at least is required
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
