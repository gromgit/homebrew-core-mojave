require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.30.tgz"
  sha256 "746bfe3b4e99b34044d702b0c3ffc5d3143a6d572df93750dbcd500ff7876fd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de976fe8af9f05b7ffc31d18d83fc8fe3da0465dd81b8df90252294711b24298"
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
