class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/08/f1/e94061a6022709b946df5aea146bac328b1f8b32c4ab0a43f96a7c26a271/djhtml-1.5.1.tar.gz"
  sha256 "d3b9060e9c45e2a56125203f2508ae591aba41a2f14ed2fa8bafb99b0fc15eb3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djhtml"
    sha256 cellar: :any_skip_relocation, mojave: "388631549726cf82d88c6f13d9380c7a06f00a879673765ec985d2da73f0e2bd"
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
