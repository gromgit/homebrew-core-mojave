require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.41.tgz"
  sha256 "c30a9bd3accde6b2d3ff357d0b52d431c2c5c5d48ad8f0f8fade6a45d0e947a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c321ead8f6ac6f5c493227370ef93b061f7e103192c49f177c969c8f674faab"
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
