require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.3.tgz"
  sha256 "5bd04175c5d075b58448cf4fff3a2c6a760e28807e73f4a8f1ab0adf14d7c926"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gtop"
    sha256 cellar: :any_skip_relocation, mojave: "dbda516e9282e42cd7ac84102645e12de06ef840f8d7ef87419c6bdb8cd37d70"
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
