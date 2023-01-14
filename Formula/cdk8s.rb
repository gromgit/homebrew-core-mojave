require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.104.tgz"
  sha256 "46bc3421b27f135f587ea0668e4af06813fbbb567604250fe8c0635fa99dbcdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b81a1f771bc58fb860a723a20d52064fe5e1b1d59468a2ffdd842886aa6a3ab5"
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
