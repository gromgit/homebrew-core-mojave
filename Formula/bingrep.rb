class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.0.tar.gz"
  sha256 "3bc4ebaf179d72b82277e7130d44c15e2cc646d388124d0acdb2ca5f33e93af6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bingrep"
    sha256 cellar: :any_skip_relocation, mojave: "3ca73186281c00d79bb3dfab3fa2b645e395425b4d72b872ed11ce8282829613"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
