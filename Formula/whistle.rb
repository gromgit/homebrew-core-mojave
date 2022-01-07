require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.10.tgz"
  sha256 "ac838815f1e9214e25a74bdc3f40bea4606923f4857f04ced502a228959839b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71ece8998ef723055b25e65b70612960a56c3f8a3f2f907df2bd0a439c7aea4c"
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
