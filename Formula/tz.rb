class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "96be9896deb2e27452d2dfde4d7121a1bd6fa1f8eec3d3b8f374b4d55626043d"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tz"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "132d6904a3f320563a312635f2e0c16e9346f5296ed376c4075c390a04786004"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position.  For now we just run
    # the command for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/tz", "-q"
    sleep 1
    Process.kill("TERM", pid)
    begin
      assert_match(/\e\[/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
