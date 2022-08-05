class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.4.0.tar.gz"
  sha256 "38610a97665a30a3b66519df41f979a39a0503d2e9ac6e1e3e3394ec305e7987"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grex"
    sha256 cellar: :any_skip_relocation, mojave: "7d27da98b734043d400441b05ccb7bf3b6917940615f8ebb67517fbd58a657a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
