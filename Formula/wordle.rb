class Wordle < Formula
  desc "Play wordle in command-line"
  homepage "https://git.hanabi.in/wordle-cli"
  url "https://git.hanabi.in/repos/wordle-cli.git",
      tag:      "v2.0.0",
      revision: "757ede5453457f58b5299fec0b6a0e79fbb27fa9"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wordle"
    sha256 cellar: :any_skip_relocation, mojave: "9313f70ccabf183701895371ad6791fa94913e482f03e29a4a68206abcec3229"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/wordle")
    prompt_first_line = stdout.readline
    striped_line = prompt_first_line.strip
    assert_equal striped_line, "Guess a 5-letter word.  You have 6 tries."
  end
end
