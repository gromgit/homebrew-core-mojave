require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.11.0.tgz"
  sha256 "314885f2c9437846f37c1c771618d2fc42a7e7f44e384591baa54265eeb4a689"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitmoji"
    sha256 cellar: :any_skip_relocation, mojave: "899d9ce81281ead9d0c6c49600341ede407a8f18075258b18a0d70caae8eca25"
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
