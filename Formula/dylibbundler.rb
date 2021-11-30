class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.2.tar.gz"
  sha256 "6aed5e11078e597e3609cc5a02dfacb4218c12acc87066f6ae9e2dfb3b7c0b35"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dylibbundler"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a93b3cc8703cc414a73dcd6c825e0316fc0611712d12f78493fbe60e67d87b9c"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
