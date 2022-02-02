class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.4.tar.gz"
  sha256 "839c6a30be2c974bba70ab80faf8167713955bb010427662b14d4af7df8d5f19"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dylibbundler"
    sha256 cellar: :any_skip_relocation, mojave: "aabfd5686086d7e52f177a86a9499405893ac1f43e662f2926534259752439be"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
