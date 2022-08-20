class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/71/66/d5e8b69e1572e0165be57fd980ef74394dcea0f49d810407eab2c46449ef/codespell-2.2.1.tar.gz"
  sha256 "569b67e5e5c3ade02a1e23f6bbc56c64b608a3ab48ddd943ece0a03e6c346ed1"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/codespell"
    sha256 cellar: :any_skip_relocation, mojave: "11aee07f3b9bb98467b85a60c47aec8cf0892e5f78c9efbebe61b27d4d0aefd4"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
