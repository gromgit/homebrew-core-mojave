require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.10.tgz"
  sha256 "7fab460bd84596b81079cf9e320bcf539702fef3b619e64eedabc3011d3f17da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "576ad6f460393aa416d58d3dd61603473f5d7967515ec1f00c222c6e5c910480"
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
