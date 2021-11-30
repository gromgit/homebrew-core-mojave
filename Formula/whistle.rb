require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.6.tgz"
  sha256 "4f0a9c4007da116f3f61ec67acf5d58d4e90f98e8d5b672a1076a07dc8c982c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ac24c760b8d261872c2e74e44c9b2b85b025ced1e4e69804080307859674e7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
