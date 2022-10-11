require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.31.tgz"
  sha256 "4aae7273997e5b2f03cc9ea613be4f5832c70880e923235176c7624998632c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91533f2127fe5f4c8a74efe7c8c6c5e54d108f3cb977eb6b13264e82222ee7ef"
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
