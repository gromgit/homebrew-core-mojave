require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.1.tgz"
  sha256 "9d1173cf1f4a557d7ae426647ec4ca7679c31fd2186dcbb89053a6e81538fa53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88fc482aceb30b35537f693da33ea766f1632ce6591aa98f8020e9bb6b342c5a"
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
