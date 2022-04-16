require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.148.tgz"
  sha256 "56671034183517ffc01374e32743a481d15eba2b8bbeee896fbe50e5263908eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd20fb3365f738244dbdabf953b580536d52580e0d04b7d9f0ca0698573b789c"
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
