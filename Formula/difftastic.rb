class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.39.0.tar.gz"
  sha256 "ba05464d8a5c77374cb9a07d901eda56c67f4d558def515454bc4b7431c8ca38"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/difftastic"
    sha256 cellar: :any_skip_relocation, mojave: "82efbdd4aba65bf0b605da8e11c41f5b3cbf59baf208da5117c8400d14816ebc"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
