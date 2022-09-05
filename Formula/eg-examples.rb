class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/8b/b7/88e0333b9a3633ec686246b5f1c1ee4cad27246ab5206b511fd5127e506f/eg-1.2.1.tar.gz"
  sha256 "e3608ec0b05fffa0faec0b01baeb85c128e0b3c836477063ee507077a2b2dc0c"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eg-examples"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8ad5951295b60ccd37774e71973cca05ad9a99adf1148b1d05ef2549e1cfefb6"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
