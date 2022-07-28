class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.03.tar.gz"
  sha256 "95012c62883ab5826e6157557a075df98cce3cbce2a48bb40851bcc968a8441a"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stress-ng"
    sha256 cellar: :any_skip_relocation, mojave: "866e80ba30cdbcf1ea75397231bf85b31ed4e5b9e7701e9e501ef414cbc85c88"
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
