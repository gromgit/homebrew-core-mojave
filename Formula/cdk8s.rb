require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.37.tgz"
  sha256 "46f0d022c659875afdc9a42b6344c4b050ccb52ee1d0b850a9f006e90def8cd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb5e7ae86e861eaef1af1b1774695ff3f6055faa4a99c8625fbdf56a3435371d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
