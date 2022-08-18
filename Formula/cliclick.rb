class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/5.1.tar.gz"
  sha256 "58bb36bca90fdb91b620290ba9cc0f885b80716cb7309b9ff4ad18edc96ce639"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cliclick"
    sha256 cellar: :any_skip_relocation, mojave: "0dfaeb2f42a1eaca530b0121c704530ee0de3981554e5ecf5b8b9c54fe308950"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
