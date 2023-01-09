class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.4.1.tar.gz"
  sha256 "8413aae520d696969525961438d22e31cd966058ce3510e91e77da18603c96b9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grex"
    sha256 cellar: :any_skip_relocation, mojave: "f8e581c38262f826d9afd5c7ec0a51958cf00c11e6b2c840f83217644554b627"
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
