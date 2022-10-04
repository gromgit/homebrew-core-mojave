class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/fc/3f/46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70/mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mu-repo"
    sha256 cellar: :any_skip_relocation, mojave: "6bce8c91e5a6555bf90de8b3d9944f9fb4b68a4dd7f309a732aa05369d8283b1"
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
