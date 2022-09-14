require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.30.tgz"
  sha256 "067af349ecdc3e9d241045b420aa682e11f24f4cb43bdcf31b5df3965d8ee71d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43ddcd11c9750c19edd70cc4278f5ce2aaae7b8c2cc230ba8c0404cdedf45d1f"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
