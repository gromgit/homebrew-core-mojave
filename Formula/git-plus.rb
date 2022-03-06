class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/e5/01/f7ff2dc29fd5b8ffe1382c5e44d4be671ea00000cb216ad2b67b8e58a5b4/git-plus-v0.4.7.tar.gz"
  sha256 "22e0e118ed94bdc4413a763774e8cf8dfd167a1209b9ee831eac1835d4bb5302"
  license "Apache-2.0"
  revision 1
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-plus"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4d8c1096371f5572e67074e3741811f1313645793f4edc983593faef9fd715a4"
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
