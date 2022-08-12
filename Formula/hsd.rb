require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v4.0.2.tar.gz"
  sha256 "ee58d681491bee90299ea2fa18656ac26fc6aef2bf3e363cb996be5015b06feb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hsd"
    sha256 mojave: "87d59979022ef1260ba3b63ad9f265f0e0d09fb13ff192da0c1c67b4f9a1fe53"
  end

  depends_on "python@3.10" => :build
  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const hsd = require('#{libexec}/lib/node_modules/hsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}/.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node"].opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.hsd")
  end
end
