class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/0f/0e/af881028b7bcb296d8982425555865a3e76ec4df13d57a0e602864594403/reorder_python_imports-2.7.1.tar.gz"
  sha256 "1ae34422f13f5a4b4669f340774909d721bfc0a8311973c70b3a50540b595bc5"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reorder-python-imports"
    sha256 cellar: :any_skip_relocation, mojave: "a475efcb40b51a5757bae8eb0485fe27c48acb828c4bc4d328476291046a65f9"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/63/e3/74f8042eb50fe161cd08cb94bc93f17a05fe76c387aeb22087db03e8173e/aspy.refactor_imports-2.2.1.tar.gz"
    sha256 "f5b2fcbf9fd68361168588f14eda64d502d029eefe632d15094cd0683ae12984"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
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
