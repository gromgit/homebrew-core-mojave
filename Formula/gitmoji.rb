require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.1.tgz"
  sha256 "c0031d926c07ecfb3d03b27b0f26ed9c2711749015f5766109e87bfac1e6791b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitmoji"
    sha256 cellar: :any_skip_relocation, mojave: "f4bb6635930bfcbaab8b2a963450f27f3a747f0037f7b09f6889f0c665f52603"
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
