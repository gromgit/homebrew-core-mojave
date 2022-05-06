class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/0f/09/03893c8de481420a71476b47ca5e1a09a9aba111802de7ad24957a72d129/reorder_python_imports-3.1.0.tar.gz"
  sha256 "6b7a810ee77a9be0e646033d034ce02457e32597c5f48e5faec1866ca9eb4957"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reorder-python-imports"
    sha256 cellar: :any_skip_relocation, mojave: "9c52da9bf73a43a6aceae434b8131fc20b928d94fac103e023ff871009e98eff"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/8a/f1/2cc8c8b9e4de77ee1b3ba889eeafb68ab0b38b28d856b48b821b9d361f41/aspy.refactor_imports-3.0.1.tar.gz"
    sha256 "df497c3726ee2931b03d403e58a4590f7f4e60059b115cf5df0e07e70c7c73be"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
