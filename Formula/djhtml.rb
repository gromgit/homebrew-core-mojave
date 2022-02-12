class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/89/9d/dfcf0ff768ccad182719e0d218b067f98ae23a7ce5bfeb272dc0915b2a7f/djhtml-1.4.14.tar.gz"
  sha256 "04de986f913a4c474c12fcadd9868f415fd92136bf5e2fbd0ab004be5839bbd5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/djhtml"
    sha256 cellar: :any_skip_relocation, mojave: "f5902d8e7e1a4f2b25c187f63b2a0dbb8bbc5cfd606984169079f2963f95bb00"
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
