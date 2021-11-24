require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.4.tgz"
  sha256 "4d828da3a4a7dd39f2ee26359f9506c9d97214f1cb088bab2c915521d2cb41d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a7e30e83b066608858545b50495654e858a1c2b361e03b3943c6dc2e2f7def5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
