require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.85.tgz"
  sha256 "4f3b3fe8431ea4b466b2e8398700920f6baf29cdd4c5866140f6d4b009422634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fbdeec1bda99a34ea2aecc23630c53860043a52c30acf3d1f9eac1bb79163b1"
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
