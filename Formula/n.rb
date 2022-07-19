class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.0.0.tar.gz"
  sha256 "37a987230d1ed0392a83f9c02c1e535a524977c00c64a4adb771ab60237be1c6"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/n"
    sha256 cellar: :any_skip_relocation, mojave: "22fc6ee54f7100c38558c8bbc044a6e5709088ef9ea9c6085265f6eda61d400b"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
