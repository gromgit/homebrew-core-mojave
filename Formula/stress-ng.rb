class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.00.tar.gz"
  sha256 "cdb18c7dfcdeb0ff2d716c141341d1b2ca6051e4338cee3a555a65f26958c256"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stress-ng"
    sha256 cellar: :any_skip_relocation, mojave: "84c068731c34d25b43a602aa714a2ba0eb4e9124e30219f9992b1149350b2b6d"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
