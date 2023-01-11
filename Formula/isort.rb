class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/e2/43/d99899bfa24a3914f0318536918ab8c91c09350b5482e4e9bb7291840ae3/isort-5.11.3.tar.gz"
  sha256 "a8ca25fbfad0f7d5d8447a4314837298d9f6b23aed8618584c894574f626b64b"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/isort"
    sha256 cellar: :any_skip_relocation, mojave: "ceae9c89d693c4a277a0501617331ee234547eb9b570e2f47573bd97fd615344"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
