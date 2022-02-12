class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  # Change to main site when back online: https://github.com/pyinstaller/pyinstaller/issues/6490
  homepage "https://pyinstaller.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/47/88/cbc8ee5a300988e67f54f0366fd4d74a01f24caff75b5dd5139c0c6223f3/pyinstaller-4.9.tar.gz"
  sha256 "75a180a658871bc41f9cf94b6f90ffa54e98f5d6a7cdb02d7530f0360afe24f9"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pyinstaller"
    sha256 cellar: :any_skip_relocation, mojave: "73e7e0b27974aa5111bea8e8afa5667dd7ba70de233181e3bbd87ba353264cce"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/c2/c1/09a06315332fc6c46539a1df57195c21ba944517181f85f728559f1d0ecb/macholib-1.15.2.tar.gz"
    sha256 "1542c41da3600509f91c165cb897e7e54c0e74008bd8da5da7ebbee519d593d2"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/59/e7/92c24ccf57f2a7ceeb0b40b793776fa68663ed3eba7643588eafd2a826d0/pyinstaller-hooks-contrib-2022.0.tar.gz"
    sha256 "61b667f51b2525377fae30793f38fd9752a08032c72b209effabf707c840cc38"
  end

  def install
    cd "bootloader" do
      system "python3", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
