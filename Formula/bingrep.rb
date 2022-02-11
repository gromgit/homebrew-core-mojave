class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.9.1.tar.gz"
  sha256 "25db3c1d3e8c8dc9a41c6b87199f320c79b1a2706e8a4f68d2590fce71dabf8a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bingrep"
    sha256 cellar: :any_skip_relocation, mojave: "04983031a7f17493adeab9b13e2e217eee6aada77e0967bd35057cf97932eb65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
