class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
  sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/python-markdown"
    sha256 cellar: :any_skip_relocation, mojave: "2f89e3097b2622adb1e6c82f261372074b33b84a4d1a238b150b3bfb5a47ddd5"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
