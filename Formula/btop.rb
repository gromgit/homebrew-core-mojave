class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aristocratos/btop.git", branch: "main"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/aristocratos/btop/archive/refs/tags/v1.2.8.tar.gz"
    sha256 "7944b06e3181cc1080064adf1e9eb4f466af0b84a127df6697430736756a89ac"

    # Fix finding themes on ARM
    # https://github.com/aristocratos/btop/issues/344
    # https://github.com/Homebrew/homebrew-core/issues/105708
    patch do
      url "https://github.com/aristocratos/btop/commit/a84a7e6a5c3fe16b5e1d1a9824422638aca2f975.patch?full_index=1"
      sha256 "f7dd836f5fcb06fe4497e9d7f2c0706bbe91a1b8a1d9b95187762527372fb38c"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/btop"
    sha256 cellar: :any, mojave: "0f72801f627545d28efb31daa826ec0bb6a896724b25dfed5da94886d2fd6f98"
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
