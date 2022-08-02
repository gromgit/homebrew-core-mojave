class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c6/63/3a87df61a5d8e1b2ba116f4889f3dbc2717ebe2e34c77b2d34e4e6b9deef/SCons-4.4.0.tar.gz"
  sha256 "7703c4e9d2200b4854a31800c1dbd4587e1fa86e75f58795c740bcfa7eca7eaa"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scons"
    sha256 cellar: :any_skip_relocation, mojave: "f4b2dc4152373424f8df6f9d8fff6e23e231443bd8897128445318468f23753d"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
