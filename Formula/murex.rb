class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.10.2400.tar.gz"
  sha256 "4503e20d144cdadf60e01b97d420bc3ab7d35b3c079712fd3e37477bdeac67b3"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/murex"
    sha256 cellar: :any_skip_relocation, mojave: "006e388fc36e5ee0770f8d4681e5a90cedb073101034e966d63cac5f7f71471e"
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
