class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.36.1.tar.gz"
  sha256 "f7ffd83be50918993669a60821f037af110b809f4cd330ebd59c0b51418a6fa4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/difftastic"
    sha256 cellar: :any_skip_relocation, mojave: "ee22b1123b7cd88872322c4579df5cf7c1708959d55e35e459c037034fd85cee"
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
      1 print(42) 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
