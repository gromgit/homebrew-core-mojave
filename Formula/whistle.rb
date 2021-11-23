require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.4.tgz"
  sha256 "016f6a381f73c57a93b57418b554018b464d79ce22802591f0ca7f7f9eb9b800"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3fa9c1cdb5e635e1e09f228c572c2b841cc3e203d6a0cf07e8f93f0b40ea6ca"
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
