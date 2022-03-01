class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/d4/2c/86e8549e349388c18ca8a4ff8661bb5347da550f598656d32a98eaaf91cc/darglint-1.8.1.tar.gz"
  sha256 "080d5106df149b199822e7ee7deb9c012b49891538f14a11be681044f0bb20da"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/darglint"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "055461507c5c48bfe2c363f7e0ad3cc8a9b74c97a8cf9cfcd0763a9769902ff6"
  end


  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end
