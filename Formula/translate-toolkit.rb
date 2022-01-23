class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/43/62/413b9a7d76f651fc61c4a0f24554f3023a63b243340ddf12427ecc3a9621/translate-toolkit-3.5.3.tar.gz"
  sha256 "b7ca3e0e8f69c306c372e05a0a814ecafa6176d30ce314e787378dabf3e48dfb"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/translate-toolkit"
    sha256 cellar: :any_skip_relocation, mojave: "a2e7d28e3ae04d4dc1762d0e2af8570a9e60653ba3b4c60bbcb55fefe4de6517"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
