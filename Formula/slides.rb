class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9180bc3fe88b44fe254c14d89c8554c442c3cfc6a1c1cd8f482db3f3ef13098d"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/slides"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "411b2eac51f1352437d4bf2f348a9a6107490cc8c787fb354df69fea9b662801"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.md").write <<-MARKDOWN
    # Slide 1
    Content

    ---

    # Slide 2
    More Content
    MARKDOWN

    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position. For now we just run the command
    # for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/slides test.md"
    sleep 1
    Process.kill("TERM", pid)
    begin
      assert_match(/\e\[/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
