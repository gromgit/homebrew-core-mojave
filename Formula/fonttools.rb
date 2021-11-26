class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3c/d5/f722e0d1aed0d547383913c6bc3c4ff35772952057b8e2b8fe3be8df4216/fonttools-4.28.2.zip"
  sha256 "dca694331af74c8ad47acc5171e57f6b78fac5692bf050f2ab572964577ac0dd"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5704a0ca1751b977e886bac6282008de3cc3f3782d935d78fcd3989658ae6f07"
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
