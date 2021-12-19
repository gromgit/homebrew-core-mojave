class Amfora < Formula
  desc "Fancy terminal browser for the Gemini protocol"
  homepage "https://github.com/makeworld-the-better-one/amfora"
  url "https://github.com/makeworld-the-better-one/amfora.git",
      tag:      "v1.9.2",
      revision: "61d864540140f463a183e187e4211c258bd518bf"
  license all_of: [
    "GPL-3.0-only",
    any_of: ["GPL-3.0-only", "MIT"], # rr
  ]
  head "https://github.com/makeworld-the-better-one/amfora.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/amfora"
    sha256 cellar: :any_skip_relocation, mojave: "11ef1bbac621d6fd4da453b49054812310d2581b4a76cab467af92935857b58d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    pkgshare.install "contrib/themes"
  end

  test do
    require "open3"

    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env TERM=xterm #{bin}/amfora"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "q"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# New Tab", screenlog
    assert_match "## Learn more about Amfora!", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
