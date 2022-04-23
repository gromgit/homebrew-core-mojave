class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.2.0.tar.gz"
  sha256 "75efd9e583836f3e6cc6d793df1501462fdceeb3460d5a2dbba99993997383b9"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/n"
    sha256 cellar: :any_skip_relocation, mojave: "1002532d9a95823156f2ea55ab16220dcb3ec57162b4fd807cead661f8234535"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
