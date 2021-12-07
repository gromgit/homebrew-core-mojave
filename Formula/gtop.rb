require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.2.tgz"
  sha256 "04fa0e7d72c07c863258d802d1fd1fbb421ea7ec9130d69dc079be8771c621fc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gtop"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "ccdbbf0a0933d883caeba2d186ddd82d6bf9d6041a2cbb99a0b2a7cb07e2dd2e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output(bin/"gtop 2>&1", 1)
  end
end
