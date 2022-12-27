class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/42/57/2b07dc5eb131d34a820bbc08a4437ca2ddfff7a47476bffd1822437de910/codespell-2.2.2.tar.gz"
  sha256 "c4d00c02b5a2a55661f00d5b4b3b5a710fa803ced9a9d7e45438268b099c319c"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/codespell"
    sha256 cellar: :any_skip_relocation, mojave: "c7b47dbd9ce844615a59bd0a67368538ab5c3dec23a89388c1ee55e624145793"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
