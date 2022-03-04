class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/59/d5/bfd2aa456d1c3b335ef32fb4ff7dc765278060ab7a9f3408e0b798d8bef6/dynaconf-3.1.7.tar.gz"
  sha256 "e9d80b46ba4d9372f2f40c812594c963f74178140c0b596e57f2881001fc4d35"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynaconf"
    sha256 cellar: :any_skip_relocation, mojave: "dc2bb90bd0b1b9a6a94abc14584b6755f824a975bd1a1bba532438ccd7560ef1"
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
