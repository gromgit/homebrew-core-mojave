class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com/"
  url "https://gitlab.com/dps8m/dps8m/-/archive/R2.0/dps8m-R2.0.tar.gz"
  sha256 "bb0106d0419afd75bc615006bd9e3f1ff93e12649346feb19820b73c92d06f0d"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dps8m"
    rebuild 1
    sha256 cellar: :any, mojave: "d2e2174c87275fd4390afcf386fda3c164dca926aecd4a34687f4a2935862944"
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
