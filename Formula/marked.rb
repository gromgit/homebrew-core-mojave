require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.19.tgz"
  sha256 "bc942e1b88a498030cfe6e253a4e6347f1d533dfe859e71e3e9da774e456ce16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9490740141a2ad190b8d22ae3ca340b817827722d0d01dc1bd35b57ba249fb10"
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
