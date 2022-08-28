class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.3.tar.gz"
  sha256 "c83183ac91becc2ee281da5d8e67d2a25b7bd750f437e5d3f0214051c7162aa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbca08614a3794ba4002544c8ca2c7fe5d28e66282b580a7f69b957071e24615"
  end

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output("#{bin}/ugit")
  end
end
