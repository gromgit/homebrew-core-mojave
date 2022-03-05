class GerritTools < Formula
  desc "Tools to ease Gerrit code review"
  homepage "https://github.com/indirect/gerrit-tools"
  url "https://github.com/indirect/gerrit-tools/archive/v1.0.0.tar.gz"
  sha256 "c3a84af2ddb0f17b7a384e5dbc797329fb94d2499a75b6d8f4c8ed06a4a482dd"
  license "Apache-2.0"
  head "https://github.com/indirect/gerrit-tools.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gerrit-tools"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5adb2effd6d7e14339030534504d25797bd2be214c96051bb2abb42f66bb3238"
  end

  def install
    prefix.install "bin"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "https://example.com/foo.git"
    hook = (testpath/".git/hooks/commit-msg")
    touch hook
    hook.chmod 0744
    ENV["GERRIT"] = "example.com"
    system "#{bin}/gerrit-setup"
    assert_equal "github\norigin\n", shell_output("git remote")
  end
end
