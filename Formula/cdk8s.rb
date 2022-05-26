require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.2.tgz"
  sha256 "cf09bded1dca76baa94d3fe1938b3cf284df3a6d91e208847c20b7c35ab19e60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c009678476e0730f971ac18b73644a702a23b4e6a4d4dc97d822fa9edb29f8e"
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
