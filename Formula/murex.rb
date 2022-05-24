class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.7.7500.tar.gz"
  sha256 "9066ac189c989f6e65d2b040b1c43c996b77ef0cb98be73c991b674c0dea1add"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/murex"
    sha256 cellar: :any_skip_relocation, mojave: "55dfeef8c838d56546bc1c59b55136f5f8070817cef7a2cddc83570eba62c4ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
