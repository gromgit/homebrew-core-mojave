require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.5.1.tgz"
  sha256 "2db9110490a01474032b198cca7e279866bb6dd8bcab3ed81eccfd1478164e6c"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prettier"
    sha256 cellar: :any_skip_relocation, mojave: "6d9579e05c6a7fb79025f477b2912dcba119e8f908ac09a007923e3912b59c87"
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
