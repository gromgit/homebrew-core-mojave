require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.18.tgz"
  sha256 "56253dd453855dc73b4416bb0f06660524dd5da22c3ad01ec9a5ce1db3582907"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a09210cc72d86b4f4c4aa4b5c1011cd179c33e44f77ffe4535fa0eff781bbc5c"
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
