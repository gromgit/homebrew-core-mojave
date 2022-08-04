require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.72.tgz"
  sha256 "bb4976817ed3682fcca86fbcb6a857a2c2f563bcc41b3c11486e11a5788cfe8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45627a1382f9aa0607e08d8649c1e5a25c61d36d925b9a6e725cde46629cb10f"
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
