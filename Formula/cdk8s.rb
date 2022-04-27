require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.161.tgz"
  sha256 "ce2bb0b0864e474d5dc54fc42e1bbe2942a9201305026e8dee6418e763313df1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e856c4b63c580caed3a6b90dc9a4ff428b80837b6cccd38d9e04fdba020b8d3"
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
