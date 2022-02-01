class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.9.0.tar.gz"
  sha256 "4db58c2d5b0fcf8c325ddb5ed6e63e2f1da5007743359bac1868587460657e4d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bingrep"
    sha256 cellar: :any_skip_relocation, mojave: "c942bd000b14940433331219c85a4740148c3ec51d8efc9382f64883883446d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
