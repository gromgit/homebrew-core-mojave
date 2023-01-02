class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/7c/40/5af5a63afb366e825998d7e618c9331661582e9366da2c21c1e1973e90c3/dotbot-1.19.1.tar.gz"
  sha256 "17a770bfbf72deaddd5c054d26a8c2353ad145ed61c8de9d898134b825696e6b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dotbot"
    sha256 cellar: :any_skip_relocation, mojave: "a9b4037f7148471c6a858611f62d0ee1cbcb83b8122c47ffe9540ce49d77f33a"
  end

  depends_on "python@3.11"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~EOS
      - create:
        - brew
        - .brew/test
    EOS

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
