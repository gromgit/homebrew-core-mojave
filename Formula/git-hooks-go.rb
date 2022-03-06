class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/v1.3.1.tar.gz"
  sha256 "c37cedf52b3ea267b7d3de67dde31adad4d2a22a7780950d6ca2da64a8b0341b"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-hooks-go"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cac53df00398e0c00ad3ea5b69cf6d06818764ede26ed8179a1ad1f0246e7962"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"git-hooks")
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
