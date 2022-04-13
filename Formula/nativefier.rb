require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.0.0.tgz"
  sha256 "dae80b4d83fe3a3dc9a1a9260d121882e1beca14ff9a4f3154836540c759311e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    sha256 cellar: :any_skip_relocation, mojave: "94cf2871229bded6e3bebdf3caee0fe8fa8133d0d06aae136d84ce82defb68ee"
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
