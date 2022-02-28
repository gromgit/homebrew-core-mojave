class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/70/e7/a1adb755aae35784ccb4323cde1216a71899bd68952e28ce1427b8f20533/translate-toolkit-3.6.0.tar.gz"
  sha256 "dfdb19383920948e5bc1dafacb994ee07f8d6ecc053cd6e2b4c545ce0430ddff"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/translate-toolkit"
    sha256 cellar: :any_skip_relocation, mojave: "e74168c0a250ac68adc64771aac1474965849762de3ea2fd67a56807e2472ac3"
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
