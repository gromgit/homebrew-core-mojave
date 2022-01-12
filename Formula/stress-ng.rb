class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.10.tar.gz"
  sha256 "972b429f9eb0afbceabf7f3babab8599d8224b5d146e244c2cfe65129befb973"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stress-ng"
    sha256 cellar: :any_skip_relocation, mojave: "f52aa5c08cf974ef3e71300f1fa4764293ed1114f9fc3a300a332b66644aeb79"
  end

  depends_on macos: :sierra

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
