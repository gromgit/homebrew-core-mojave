require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.91.tgz"
  sha256 "3aa18b76b530706192236eaf034c8fe116dec7fb575fc4bff5e0224c95ef5822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9af9bb9ed230dc07de70a5e7312844deb5dd61da978d4448ba3249e1d7c47e9b"
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
