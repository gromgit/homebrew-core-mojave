class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.5.tar.gz"
  sha256 "13384ebe7ca841ec392ac49dc5e50b1470190466623fa0e5cd30f1c634858530"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dylibbundler"
    sha256 cellar: :any_skip_relocation, mojave: "f34e0827591a06fe19e1cb2983dbe5011910d660e5dfe0c478273c1360164828"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
