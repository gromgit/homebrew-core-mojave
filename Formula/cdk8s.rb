require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.63.tgz"
  sha256 "b92e13a66e839e46f71ee0bcb4646bc4e2a2c59fb9d35fbda1819000c7afbed6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b15f727160e8c3c336918fe6e4f978b650ec575cbc2fd30a62eecde1fffeb18"
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
