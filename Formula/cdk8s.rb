require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.7.tgz"
  sha256 "4bff7641955e51a944d16732f8a33e3e7d860faa45eb834adc327c2cbb3e2074"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37273d18f1a22d5b2aa45040358d6dbd73e11cd57cc0c2ef53542e2c5b762b52"
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
