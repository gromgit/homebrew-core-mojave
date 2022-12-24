class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.1.tar.gz"
  sha256 "e27c7e073420a5feebb3497efafad343df597b613f6e31613af1a03558c5a3e6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bingrep"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5cf47c0aa9d3644de71d08c31a89e2a36e302aeb950929c9c12f87683982f258"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
