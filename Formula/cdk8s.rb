require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.76.tgz"
  sha256 "d5bfd47098a93d0c4aed3b34b829be36ff559975b45ca25c9ba163ed9ca77681"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ad379e0c219d1b1e7c13066fb377e33b83b8fa411621b57e5a9310a35929db4"
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
