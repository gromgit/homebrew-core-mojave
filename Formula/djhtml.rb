class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/59/b3/ab2546e09f21dff93205dfad01903718ac436d134de42ff8e76c846a60f1/djhtml-1.5.0.tar.gz"
  sha256 "eeccc5e5cc6d1371e8434903de5043b24efa1000b6857b9bf342e1868aa995ae"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djhtml"
    sha256 cellar: :any_skip_relocation, mojave: "9797ff145ca855f0377fd2e230cdb22f0f178db8f88d99f6787b4880e11e4e63"
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
