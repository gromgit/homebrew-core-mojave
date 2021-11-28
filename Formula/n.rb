class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.0.0.tar.gz"
  sha256 "9e8879dc4f1c4c0fe4e08a108ed6c23046419b6865fe922ca5176ff7998ae6ff"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/n"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "45b9745a25d4d6a49760eff5156490831c57667764630833d82f430e78ebd04c"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
