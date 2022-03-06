class GitSvnAbandon < Formula
  desc "History-preserving svn-to-git migration"
  homepage "https://github.com/nothingmuch/git-svn-abandon"
  url "https://github.com/nothingmuch/git-svn-abandon/archive/0.0.1.tar.gz"
  sha256 "65c11b5e575e6af4d21ef7624941c4581a5570748d50e38714bd33fee56e4485"
  license "MIT"
  head "https://github.com/nothingmuch/git-svn-abandon.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-svn-abandon"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "214342b40fa8ee0a68937b223571fd157072ee61886f1312d132f221d5550229"
  end

  def install
    bin.install Dir["git-svn-abandon-*"]
  end

  test do
    system "git", "init"
    system "git", "symbolic-ref", "HEAD", "refs/heads/trunk"
    system "git", "commit", "--allow-empty", "-m", "foo"
    system "git", "svn-abandon-fix-refs"
    assert_equal "* master", shell_output("git branch -a").chomp
  end
end
