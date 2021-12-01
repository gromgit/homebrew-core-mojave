require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.42.tgz"
  sha256 "a46d843a10a03d38d3ff304a2239167140409211e8095d98fc96cee3c0e9fbee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d404b9a29157d2d475e67cccdd09fc0f7eb51874769384390701e74a6e66d888"
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
