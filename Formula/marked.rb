require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.4.tgz"
  sha256 "2762e8489f3d25469ec863432870a523a474afddced410e028411b5ea585a705"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "883b9fb3a99bd5f8577d2be32fba53f4ab172225fda1c45669f7488f8edf5740"
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
