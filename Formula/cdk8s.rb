require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.56.tgz"
  sha256 "620e066faf3cf6ad9325c2fd710df6f327043ae633ff955ba71bfd662c6cf7d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e616d7758f6bd07271528d2ad1d0743597dafa3cc943b34b8d6148ae3116ba6b"
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
