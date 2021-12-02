require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.5.0.tgz"
  sha256 "21faa55daf1ea29fb1c021689808d44f7d57a297a9b73cd092bf58faed53aee1"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prettier"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "55e6418fe02f13f7d804b0309999340c5d1c960144601078729211ffdc4e2314"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
