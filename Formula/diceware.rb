class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/diceware"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "42cd8c219f04856449c4abe901e66f253578263f4b204f6d6a266e93f9dd98e9"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
