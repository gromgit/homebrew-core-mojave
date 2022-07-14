require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.49.tgz"
  sha256 "61a29bec36190139d564bc70776e8b35cfa362f90410fb050ff03c47f32fd9de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d564cb61cce84159b448360aa4076c9afac4c96ff551a7e3c2481fc92a01e689"
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
