class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.6.0520.tar.gz"
  sha256 "0c29e423bb82ea035d059efc835522018e4f59bbeb9e61e5bcc2e812daa875bc"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/murex"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f6c3b88e75fec8ef45711bf0f33cf46c0e5bbc6b7126e864739c3e65b2684fbd"
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
