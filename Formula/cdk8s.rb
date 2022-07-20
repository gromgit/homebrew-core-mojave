require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.55.tgz"
  sha256 "0c8a2a49084a9ab34057dc02ffd21a912f2a9a7756f44d38dd9ef80ea6eb24fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15c9acdbe4c4a65a014bf7fb3127133dc84bef287cd9aaa10505bbbee2702699"
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
