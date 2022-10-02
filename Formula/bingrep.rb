class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.1.tar.gz"
  sha256 "e27c7e073420a5feebb3497efafad343df597b613f6e31613af1a03558c5a3e6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bingrep"
    sha256 cellar: :any_skip_relocation, mojave: "3f4b45598dd36cc431867d96419d441134fc4ab871983e55de2c3ebc3f414eaf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
