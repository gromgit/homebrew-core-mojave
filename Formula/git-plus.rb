class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/b4/c8/11b61003533e8afc5e5730113c7b21f2268db87a46f37e2d910fb9bb7d76/git-plus-0.4.8.tar.gz"
  sha256 "4df7103a4a56cec52ca6b93cd1626b727ace76c9d6673a084a473fac84ae5ff8"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-plus"
    sha256 cellar: :any_skip_relocation, mojave: "2b05fd7bb5104131594b5700fa86e34b6211a7aa0e5dadf079373e03adf8ca4f"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
