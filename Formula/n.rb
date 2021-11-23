class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.0.0.tar.gz"
  sha256 "9e8879dc4f1c4c0fe4e08a108ed6c23046419b6865fe922ca5176ff7998ae6ff"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
