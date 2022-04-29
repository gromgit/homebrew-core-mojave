require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.0.tgz"
  sha256 "53359e86afaea0519f8956db1e121b8cee1a3fa2d83bd3b9239a67b478a01fb2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitmoji"
    sha256 cellar: :any_skip_relocation, mojave: "5c233192b38cd363ade53feb34fd70dace3b63f18623f847358f887535c465fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
