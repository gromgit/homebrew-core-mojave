class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9a66db51e729713df102def0c2c02b786bb09c2b024204c515f9c0dd721382aa"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/viddy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b76bdb2fd5d2fec3610e64a70171abbd2deefbbe0306fd8a7dc39e244d1f8c10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["TERM"] = "xterm"
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/viddy echo hello"
    sleep 1
    Process.kill "SIGINT", pid
    assert_includes r.read, "Every"

    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
