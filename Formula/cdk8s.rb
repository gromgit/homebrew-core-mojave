require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.155.tgz"
  sha256 "e2aba7cf51a7429b5ec88c9e67eea19e9ef728be30d4143a68ddf8bd29abe90a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7492b9b416e39f5c0681505cee8991ad1c94bdfa73576564600c4c9926cc9fb3"
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
