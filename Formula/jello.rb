class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/39/35/cb9eacaab1d7845fc5f2dd086e31dc980cfeec563a4e070f980ecc6c025a/jello-1.5.0.tar.gz"
  sha256 "62aff5a06761457ac72285a377cdfd7f8555fe1c791e7c9e7783711266bb4f30"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jello"
    sha256 cellar: :any_skip_relocation, mojave: "e356e25ec6da3818c44a0f7b196cce5d34cb0a2586db3b0ccb300c2a5825b680"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
