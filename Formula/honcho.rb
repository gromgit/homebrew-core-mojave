class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/honcho"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "670036cac190b715c641d71635a8c54d0ae18d2173e3d27df712e10c13082dcf"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
