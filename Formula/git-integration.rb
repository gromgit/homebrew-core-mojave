class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.4.tar.gz"
  sha256 "b0259e90dca29c71f6afec4bfdea41fe9c08825e740ce18409cfdbd34289cc02"
  license "GPL-2.0"
  head "https://github.com/johnkeeping/git-integration.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-integration"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5bc7934d1c2e7ded1b4794518ab3091df56ab947e001cc9279408673a89f384d"
  end

  def install
    (buildpath/"config.mak").write "prefix = #{prefix}"
    system "make", "install"
    system "make", "install-completion"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "An initial commit"
    system "git", "checkout", "-b", "branch-a", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-a"
    system "git", "checkout", "-b", "branch-b", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-b"
    system "git", "checkout", "master"
    system "git", "integration", "--create", "integration"
    system "git", "integration", "--add", "branch-a"
    system "git", "integration", "--add", "branch-b"
    system "git", "integration", "--rebuild"
  end
end
