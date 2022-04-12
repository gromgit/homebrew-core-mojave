class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.26.0.tar.gz"
  sha256 "a224838b3802c876aa8bd8247d882ada98929c9ef41dba238b8d4e6ce3f419c0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/difftastic"
    sha256 cellar: :any_skip_relocation, mojave: "a1a6fd28f180ec589263ecd7442107909931c53e5e6edd084e929df0e60332b1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc"
  end

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
