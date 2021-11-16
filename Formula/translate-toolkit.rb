class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/08/a5/876e2407d0d405fde31524e04f6ea2d068e06f53afc7b5c857a2fde51612/translate-toolkit-3.5.1.tar.gz"
  sha256 "3b51f548ef9d27b4f47a33b7d4eb299119d0fff71ba41f48eb5bd9bbeeb91708"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"


  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
