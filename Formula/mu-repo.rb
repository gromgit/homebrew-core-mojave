class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/05/6b/27768e4cc1464a2b7c6b683c096edbdf38b8b994670e42814519ff067853/mu_repo-1.8.1.tar.gz"
  sha256 "1eb67031ff9d697adce375b122e0a76beb675c5ee6dfcabc848e78bdcfb4ed3d"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mu-repo"
    sha256 cellar: :any_skip_relocation, mojave: "6650a00f75a2ac0dc080e8f6e01f435d57db9af0cbb6f0bd25833c0c590b3a87"
  end

  depends_on "python@3.10"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
