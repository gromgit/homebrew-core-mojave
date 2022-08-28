require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.97.tgz"
  sha256 "1a952728285ad8c78c51370b83a3c8cd29254fffaaef6add6ce076ebc3d586fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56bd6780bb1c3a786fee4c1b8a221110cea47ccc46efbea0264ca37c63daccdc"
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
