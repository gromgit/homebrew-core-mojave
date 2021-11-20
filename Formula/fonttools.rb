class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/47/bb/7d54c8764ec928c348a329bf745bc73029742cd57efffc1530f8c5ac6d4c/fonttools-4.28.1.zip"
  sha256 "8c8f84131bf04f3b1dcf99b9763cec35c347164ab6ad006e18d2f99fcab05529"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "05b260b0f9f43748087e80f964f7d4cf88e144e59a0e5d1fbe177dfc30430f65"
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
