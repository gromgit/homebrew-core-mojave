require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.65.tgz"
  sha256 "63e876048721d90b5815704b1efe911c8299c5380e334f72763ebd8fc2374fa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b66ab6f8558d5f45fd188cb7f33ff8124a95bfdba6c2bb4107b526677859f897"
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
