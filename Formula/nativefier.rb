require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.1.3.tgz"
  sha256 "b5f75cf710cacab61c366ed367ecd243ae39e176ddf00834bded27bdd3803e7a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    sha256 cellar: :any_skip_relocation, mojave: "c473c19cea7bfa530e079780a80f570fd820b5c08289d43240f515c0839fa887"
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
