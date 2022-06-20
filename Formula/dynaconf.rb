class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f0/0e/3c102db167de3e2bb3a36a680a89c27b9b08d9f856b2164cc1a03db96f1c/dynaconf-3.1.9.tar.gz"
  sha256 "f435c9e5b0b4b1dddf5e17e60a1e4c91ae0e6275aa51522456e671a7be3380eb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynaconf"
    sha256 cellar: :any_skip_relocation, mojave: "46a93b62b260d0805e30abe427ba5893af6ee2e40e5a035502f39d880a546d3b"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
