require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.0.0.tgz"
  sha256 "c1fdc6e17b6274b8fdbdcf887789930bd3a3ddb960d23b83225ad9df36279284"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lerna"
    sha256 cellar: :any_skip_relocation, mojave: "f3583b2a8a130010ac740048400e1c6c1c525fd380ad1c71b57f446bd3f8dd8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
