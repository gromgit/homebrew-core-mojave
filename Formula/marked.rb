require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.15.tgz"
  sha256 "02ea9a9381970aecc55322d0302721d5f2fa84478d4d0ae4dd5c407814a473f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b2819ac663af17cda1002a55352c2e39229e9e1c59bd092472e1e42cb9897f7"
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
