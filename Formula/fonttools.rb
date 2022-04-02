class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/cb/d9/8f4b6d56afb0c034c65a12902df9d7b41e1ede88bf89baf19d172e9396c3/fonttools-4.31.2.zip"
  sha256 "236b29aee6b113e8f7bee28779c1230a86ad2aac9a74a31b0aedf57e7dfb62a4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fonttools"
    sha256 cellar: :any_skip_relocation, mojave: "1dc7f791133675b728f8cb395e53880e06011e92f49b009efcce8d6cd938991c"
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
