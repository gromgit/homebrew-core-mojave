require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.5.tgz"
  sha256 "2621f49273b5f0beda1659ce2aba75c6ccc2c7411536e7a11f3d3b69889fa72a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fab179e8d1a4311f127a5d3e4fa33e9eddbc06ffa348bf2ed51288ecb611633b"
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
