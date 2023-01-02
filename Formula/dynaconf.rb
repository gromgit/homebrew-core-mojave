class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/54/6f/09c3ca2943314e0cae5cb2eeca1b77f5968855e13d6fdaae32c8e055eb7c/dynaconf-3.1.11.tar.gz"
  sha256 "d9cfb50fd4a71a543fd23845d4f585b620b6ff6d9d3cc1825c614f7b2097cb39"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynaconf"
    sha256 cellar: :any_skip_relocation, mojave: "489381871dac0329723a79c90c1d4997720f54fb8a2f2a2e2bb21ddd686b242d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
