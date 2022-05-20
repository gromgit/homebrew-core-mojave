class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b6/71/1b7b4b74cfe2c3ec0ec25da29555d487c0a68be03112246a34d1f380dfec/translate-toolkit-3.6.2.tar.gz"
  sha256 "91b247b159f4fa2ae2ed9b0a6c88a2dc207f1cd3cb93f754a9059e7eaebe8c54"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/translate-toolkit"
    sha256 cellar: :any_skip_relocation, mojave: "0e899f624276d0cd4d5bbadfcef58843137df1bc939127c22f87504114ac095c"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
