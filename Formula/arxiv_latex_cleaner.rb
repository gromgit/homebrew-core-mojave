class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/50/94/1ef60b7f751ab669a420c13a6c0421efa9e9166c1ff47b76541905873758/arxiv_latex_cleaner-0.1.30.tar.gz"
  sha256 "f665fb21be34f7cfd519805f2a9cb2dfeb4ef9b2c15313824f118df49deb4b1d"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arxiv_latex_cleaner"
    sha256 cellar: :any_skip_relocation, mojave: "42c4dbc180eb3246ea542bdc799080cf7491bcfaadbaeb3bd39d5760aa1df0d8"
  end

  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/a8/66/2b190f1ad948a0f5a84026eb499c123256d19f48d159b1462a4a98634be3/absl-py-1.3.0.tar.gz"
    sha256 "463c38a08d2e4cef6c498b76ba5bd4858e4c6ef51da1a5a1f27139a022e20248"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
