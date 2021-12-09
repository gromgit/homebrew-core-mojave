require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.6.tgz"
  sha256 "2c56fd89067cf44ee15c9952976f6b2e46a27a1051599ba20207545229f812ca"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "f533e0f89295166dd9c06619a164e518821cbfc198e7548bf3caf3773085a8dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
