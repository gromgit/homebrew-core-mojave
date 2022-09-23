class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.05.tar.gz"
  sha256 "2ee20333d306037cf44f4e8d038bc6253106dcb54f37ee548e9adfd94a6a391c"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stress-ng"
    sha256 cellar: :any_skip_relocation, mojave: "ea9028e120f7b8a3896e00d4e6755c3db0ab9917f4fa7f8895d945ade4e38e40"
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
