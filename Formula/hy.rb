class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/68/bb/8f852a2a9591d53c083384f6cd95d9e857b2802668f922fa0b50468a280b/hy-0.24.0.tar.gz"
  sha256 "de3928ff7f97893bb825e59f17f3cd19e4b59beecb71c38039b8f349ca8dfe1d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hy"
    sha256 cellar: :any_skip_relocation, mojave: "388b3d022173f72d59d8543491d0a58292746116cc07d4a974f57311c603d220"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/53/6b/02fcfd2e46261684dcd696acec85ef6c244b73cd31c2a5f2008fbfb434e7/funcparserlib-1.0.0.tar.gz"
    sha256 "7dd33dd4299fc55cbdbf4b9fdfb3abc54d3b5ed0c694b83fb38e9e3e8ac38b6b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    site_packages = libexec/Language::Python.site_packages(Formula["python@3.10"].opt_bin/"python3")
    ENV.prepend_path "PYTHONPATH", site_packages

    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{Formula["python@3.10"].bin}/python3 test.py")
  end
end
