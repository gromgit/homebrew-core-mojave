require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.44.tgz"
  sha256 "3daa5ccf359758a014b2b62e31ed6bb4f57ebff8e86c9c90aa03d146d61f9dd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d248f142a90423bf9e2c60ea4e437abd36ee0fa2c071a419d9f609147c1955c"
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
