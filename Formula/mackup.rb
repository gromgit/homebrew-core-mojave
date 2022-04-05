class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/8b/f7/cb156f968c953652abcf71e4b1b2776ab6075c7d54194409ffe962e2b0e4/mackup-0.8.33.tar.gz"
  sha256 "41a45b336f99d7cc2ec4b6a9099efcf03d2cd891ff78f24cb65fe2376e8c8f20"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mackup"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "f889a2bf46f7df293d0e654a37c8c093575e4a5ef7b5d56cd769eb47c892c72d"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
