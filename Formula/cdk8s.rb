require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.116.tgz"
  sha256 "5658c6b475176727a0427676f97da3d743a42a8dfdd5e98cba11aaa2a00c6340"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4868f96f6595a691dcf6ad1643e4eff7457c84a95836f1f52cba9486fd3cf2bc"
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
