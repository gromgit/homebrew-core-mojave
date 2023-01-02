class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/26/8f/b838a00b9fa0033c210e5fddb43d41ac3f500decf840e6b251ea18c3da6e/djhtml-1.5.2.tar.gz"
  sha256 "b54c4ab6effaf3dbe87d616ba30304f1dba22f07127a563df4130a71acc290ea"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djhtml"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "caa75d112d9127bea58b3837fcae220957af1282c2054fcb51981eb6ec08b51a"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF
    assert_equal expected_output, shell_output("#{bin}/djhtml --tabwidth 2 test.html")
  end
end
