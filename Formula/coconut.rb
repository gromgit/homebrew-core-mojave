class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/55/23/81b074bc722359a56131930673ce4e65f48a5c1ad538a79a77f346c77064/coconut-2.1.1.tar.gz"
  sha256 "38ce2c38c915e305e7c060a3e902d6ca8e504410182a0d4b50abe4df31aaebe3"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/coconut"
    sha256 cellar: :any_skip_relocation, mojave: "9cd53176251cc600e93e7f030a3fcbcbb0a49264a775e72ea747f9619cb4f052"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/c6/6a/b37f4aff8f53083fe71e9b5088dd3a413c231ece8dcb0809a8f2c2b5083e/cPyparsing-2.4.7.1.2.0.tar.gz"
    sha256 "c0dc51c5dbb6d5c1e672a60eb040b81dbebbab22b8560d026d9caebeb4dd8a56"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
