class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/2c/45/76c978c725b020be65a95b8b427e3550c76478a90e5396a33b0b204cae45/dynaconf-3.1.8.tar.gz"
  sha256 "d141a6664fca3648d2d8e84440966af9f58c4f4201ca78353a3f595a67c19ab4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynaconf"
    sha256 cellar: :any_skip_relocation, mojave: "a55a36bc394a5bc1833e859f27bf11c0dd3034a41249e63f793d14d8f53fcd7d"
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
