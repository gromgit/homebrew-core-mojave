class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.1.0.tar.gz"
  sha256 "adf97836bfd66e79776b1330e84b9f089f73e9e89d3a6fd6e385a95d3eab2af5"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/n"
    sha256 cellar: :any_skip_relocation, mojave: "9bfb4d89c9452cc533e1a0031eb9177397fec72e70b1c01965558e7e33fe9c45"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
