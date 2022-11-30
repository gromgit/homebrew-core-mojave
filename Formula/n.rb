class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.0.1.tar.gz"
  sha256 "ad305e8ee9111aa5b08e6dbde23f01109401ad2d25deecacd880b3f9ea45702b"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/n"
    sha256 cellar: :any_skip_relocation, mojave: "ba3883ee8187e4990fba2df1315831f211e579ecd83f680f582c9f33af541a34"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
