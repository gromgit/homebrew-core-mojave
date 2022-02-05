class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/56/07/ea50799121005ab7f1ad6aa6e434e0ef52a74877e8097faba9eb0a97923e/djhtml-1.4.12.tar.gz"
  sha256 "e43afa8be7a4a80959c171d50c615ae1ee8ae11e4ac8e8550240759e476d5f76"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djhtml"
    sha256 cellar: :any_skip_relocation, mojave: "aaccd4b7b638d6288a417b62fac255382edef5f2237103010624c5d8ac6e17fe"
  end

  depends_on "python@3.10"

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
