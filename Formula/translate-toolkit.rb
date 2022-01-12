class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ab/c1/446eb4c232c82e045dfe282c049bc1ed92c0805693b34f3097c4fe463cb8/translate-toolkit-3.5.2.tar.gz"
  sha256 "43d8fa8d765480c822ff7931f60be8b2836fd52307a4e85e449624b9d6fecef0"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/translate-toolkit"
    sha256 cellar: :any_skip_relocation, mojave: "d43b4428ef602b597a9e961fd1e281d95e4eda9817680fe159fc46068b45a6bf"
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
