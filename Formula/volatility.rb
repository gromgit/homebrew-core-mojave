class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/7a/2a/4bbd676f58d9b4b4846b0c6eecaa2603fcb5b6d4aa35cef2df3df9d757af/volatility3-2.0.1.tar.gz"
  sha256 "e4f3f3a26b2e34e744a2d475b278556b53be769a3c897bfc4bdcbd4feb9089eb"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/volatility"
    sha256 cellar: :any, mojave: "2269003b71c489563ac84960706375e25d746352a8db1bd6e5e6113764ea35a3"
  end

  depends_on "jsonschema"
  depends_on "python@3.10"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "capstone" do
    url "https://files.pythonhosted.org/packages/0d/25/3496d5e23573bce9c1b753c215b80615e7b557680fcf4f1f804ac7defc97/capstone-5.0.0.tar.gz"
    sha256 "6e18ee140463881c627b7ff7fd655752ddf37d9036295d3dba7b130408fbabaf"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/ee/e1/a7bd302cf5f74547431b4e9b206dbef782d112df6b531f193bb4a29fb1b9/pefile-2021.9.3.tar.gz"
    sha256 "344a49e40a94e10849f0fe34dddc80f773a12b40675bf2f7be4b8be578bdd94a"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/32/09/41ea2633fea5b973dac9829de871b417ff3ce2963d07fd92e3f2d2a9ee9b/pycryptodome-3.14.1.tar.gz"
    sha256 "e04e40a7f8c1669195536a37979dd87da2c32dbdc73d6fe35f0077b0c17c803b"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/c9/d9/f0e15174adae818a8dd9bb5989a8343abc3a1df29757c5b1f00aecdd1276/yara-python-4.2.0.tar.gz"
    sha256 "d02f239f429c6c94e60b500246d376595fbed8d9124209d332b6f8e7cfb5ec6e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
