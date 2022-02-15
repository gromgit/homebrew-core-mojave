class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/c6/d7/3af4967567358fc5e6573a961ebe262179950fd5030ea1d4ee5efda1a76a/epr-reader-2.4.13.tar.gz"
  sha256 "e9fc3a8053e307cbf6aa1298c78678786329eb405f14e971f9888f69a7950212"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/epr"
    sha256 cellar: :any_skip_relocation, mojave: "673adef6aaea5ec92d9bcab2690ed7d36fcdb7602e74614ab48df27e25ac4dde"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
