class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/fc/a0/1f1c0953d4ecef4655c00678000e6456c53415b5ab4acbbf83ec252f3388/fonttools-4.28.4.zip"
  sha256 "581a682a7102a41421e7e484303572c565c1b8e52b1cc9fecd3c159dbe9a02f4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    sha256 cellar: :any_skip_relocation, mojave: "380e284e18467bbccde91aef1b41550718677e4d5ba050fbc9d5e7bf763d54d6"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
