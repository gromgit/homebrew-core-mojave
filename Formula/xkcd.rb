class Xkcd < Formula
  desc "Fetch latest, random or any particular xkcd comic right in your terminal"
  homepage "https://git.hanabi.in/xkcd-go"
  url "https://git.hanabi.in/repos/xkcd-go.git",
      tag:      "v2.0.0",
      revision: "5e68ef5b2e7e6806dd57586e9b7ed4f97f64dba0"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xkcd"
    sha256 cellar: :any_skip_relocation, mojave: "eefa9a1123ab6de16a3b831d0237a1830c407af638896554f6618249af8aae72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/xkcd explain 404")
    op = stdout.readline
    striped_op = op.strip
    assert_equal striped_op, "https://www.explainxkcd.com/wiki/index.php/404"
  end
end
