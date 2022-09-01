require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.101.tgz"
  sha256 "c113f0421448c2378282e5a3361efed99b34ee28fd985c983f7e8344524bf9e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58db6af9ad908423e85cda54492adfb1a6cc6839b64fcf3bd4b098d714376ca2"
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
