class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/b9/18/e51a6e575047d19dbcd7394f05b2afa6191fe9ce30bd5bcfb3f850501e0c/vulture-2.6.tar.gz"
  sha256 "2515fa848181001dc8a73aba6a01a1a17406f5d372f24ec7f7191866f9f4997e"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vulture"
    sha256 cellar: :any_skip_relocation, mojave: "bc1e7ec02e57c7e437a80a4fb7aefda3f42a2dd6eb62b5cace026af9deeaa279"
  end

  depends_on "python@3.10"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")
    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 1)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
