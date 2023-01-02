class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com/"
  url "https://gitlab.com/dps8m/dps8m/-/archive/R3.0.0/dps8m-R3.0.0.tar.gz"
  sha256 "cee3cc0942ceb929d267c4989551526ff50e777706f62bfc449e16d1428a1d2e"
  license "ICU"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dps8m"
    sha256 cellar: :any, mojave: "3c04626289391c828a62c9921828df55271019c11230640c1b02b3c9b0431277"
  end

  depends_on "libuv"

  uses_from_macos "expect" => :test

  def install
    # Reported 23 Jul 2017 "make doesn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8
      set timeout 30
      expect {
        timeout { exit 1 }
        "sim>"
      }
      set timeout 10
      send "help\r"
      expect {
        timeout { exit 2 }
        "SKIPBOOT"
      }
      send "q\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_equal "Goodbye", shell_output("expect -f test.exp").lines.last.chomp
  end
end
