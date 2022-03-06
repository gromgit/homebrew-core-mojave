class GitUrlSub < Formula
  desc "Recursively substitute remote URLs for multiple repos"
  homepage "https://gosuri.github.io/git-url-sub"
  url "https://github.com/gosuri/git-url-sub/archive/1.0.1.tar.gz"
  sha256 "6c943b55087e786e680d360cb9e085d8f1d7b9233c88e8f2e6a36f8e598a00a9"
  license "MIT"
  head "https://github.com/gosuri/git-url-sub.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-url-sub"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2d56fdba9468084bdffcc7323c6103af164d8638c07de41e18b52f6f0f0848b9"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "foo"
    system "#{bin}/git-url-sub", "-c", "foo", "bar"
    assert_match(/origin\s+bar \(fetch\)/, shell_output("git remote -v"))
  end
end
