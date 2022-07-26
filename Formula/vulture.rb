class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/f2/7b/5f3249c9b3076bceb2839cf7ea9847e504d180e90dfac32300403a9e7139/vulture-2.5.tar.gz"
  sha256 "2831694055eb2e36a09c3b7680934837102b9b6c0969206e3902d513612177c3"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vulture"
    sha256 cellar: :any_skip_relocation, mojave: "802b1c9c5c5c3c0789377090a42a5e51375db7e590baf23be222789dad2ff5fe"
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
