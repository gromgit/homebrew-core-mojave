require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.29.tgz"
  sha256 "e19a558beb0b55a683c4686511f29dbe3f5abf3a892e08250155a29e3f4375c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e567cb83cfe1602b341cc5e5b023d2bb903ade119334ace4e9d47d2f8f105e7b"
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
