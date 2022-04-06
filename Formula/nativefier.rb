require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.2.0.tgz"
  sha256 "386f40c1726330af86832fc41e776b0f043bf5dfafaa8f9f01038947c124a9eb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    sha256 cellar: :any_skip_relocation, mojave: "01bb5154d994fbdcee9749f87d765fce671e9991ec1b4a2a88bf14e674311419"
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
