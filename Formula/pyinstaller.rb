class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/9c/b1/5c9cf5bceade92613196b1be4b9cc1406e82d9edadb3c682da860be96cea/pyinstaller-5.2.tar.gz"
  sha256 "5efc1b3ffb13fe50a51305fe57fb9e6e7bce00d009c16dd3cb76ea4d702a04ab"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pyinstaller"
    sha256 cellar: :any_skip_relocation, mojave: "11d34e6fe0e152cf5658484e9e32014f1341a3254a06b2d9b66a35ce02c3a315"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/16/1b/85fd523a1d5507e9a5b63e25365e0a26410d5b6ee89082426e6ffff30792/macholib-1.16.tar.gz"
    sha256 "001bf281279b986a66d7821790d734e61150d52f40c080899df8fefae056e9f7"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/a4/75/a0a8e398c4b97a8fa84f110ec8be0f2f11462ed1053087d6fcc6ee4d129c/pyinstaller-hooks-contrib-2022.8.tar.gz"
    sha256 "c4210fc50282c9c6a918e485e0bfae9405592390508e3be9fde19acc2213da56"
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
