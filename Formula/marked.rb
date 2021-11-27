require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.5.tgz"
  sha256 "b5e25b272471f18e30dfd55bcec1d308ad557acc2b2f1d67fa3e20104cdd99e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f36f1eb98314141684d1dc7e29def768fa451bd4f71e9ccc7baaecc337d3e90"
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
