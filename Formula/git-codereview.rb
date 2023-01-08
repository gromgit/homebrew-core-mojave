class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2151eb3ea0a288b7f65489b8bbc835d2ee52e38d202171aa9a183ff53664e7f0"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-codereview"
    sha256 cellar: :any_skip_relocation, mojave: "7f11424ade93dfe58d471053827a0fada67608650e82bab20fcbe0d90708f52d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
