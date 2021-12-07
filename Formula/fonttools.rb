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
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2e4d51eccfc53e95a5a19f3cbfeec41e9cf15350b55efea4d5a942483c4ba57f"
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
