class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/2d/4c/49ba863863502bb9fea19d8bd04a527da336b4a2698c8a0c7129e9cc2716/fonttools-4.29.1.zip"
  sha256 "2b18a172120e32128a80efee04cff487d5d140fe7d817deb648b2eee023a40e4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    sha256 cellar: :any_skip_relocation, mojave: "cff987a6945ba6ee67e43cb5f23aa0a5da3f15ed84f1c84ebb462eccd60582ce"
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
