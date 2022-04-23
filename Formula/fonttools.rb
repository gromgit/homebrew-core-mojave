class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/b9/78/dcc2e8de564831cd1d3ab96dae972dd174eda71eb9a709d27d11cf4f3104/fonttools-4.33.2.zip"
  sha256 "696fe922a271584c3ec8325ba31d4001a4fd6c4953b22900b767f1cb53ce1044"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    sha256 cellar: :any_skip_relocation, mojave: "0b2196edadba358c09f056d1d5eb23f00771cd5b3c0ce317da176b26fdf5d546"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
