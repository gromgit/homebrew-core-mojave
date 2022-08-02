class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/92/a3/44ef2dddc89de62fc248e853edbcddcf5c1d605bb89d4c741a735ca85611/jello-1.5.4.tar.gz"
  sha256 "6e536485ffd7a30e4d187ca1e2719452e833f1939c3b34330d75a831dabfcda9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jello"
    sha256 cellar: :any_skip_relocation, mojave: "b11305e55a9e8811b9eb0a2cfdc321d7ae2448a74cf9b3a0513a8c3eb3b9d68d"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
