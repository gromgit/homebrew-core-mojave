class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/a6/12/0a174f329c980b62cf2873ccd2c9d8bacb9c51737cbf6c3481e2968860da/aws2-wrap-1.3.0.tar.gz"
  sha256 "8a24605c6fb073e4ffceb63000fa8acda8a1a4860807b16c9279bc64cf37baff"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aws2-wrap"
    sha256 cellar: :any_skip_relocation, mojave: "eb4a3b9f2fd156353c4af79b3838391f664e3cfb64c622630603032574263643"
  end

  depends_on "python@3.10"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
