require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.13.0.tgz"
  sha256 "500710a8241227619d52f8aae5c27dffe5edb8034b187bcee3b1f9542e5b072b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitmoji"
    sha256 cellar: :any_skip_relocation, mojave: "c03d1c68bf0096fc6dac45550a5a8627d9536f7126951dcdb9b9fcdd0e60e3a2"
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
