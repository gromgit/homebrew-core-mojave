require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.18.tgz"
  sha256 "56d73130550d43e191d25a863ad924ef791da718fe975a94a2671e8c90975322"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d69f721cd2107d9a6aa79197da0e436719d8622ec22af8a976720f903044fbc"
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
