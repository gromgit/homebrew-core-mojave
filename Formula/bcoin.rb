require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.2.0.tar.gz"
  sha256 "fa1a78a73bef5837b7ff10d18ffdb47c0e42ad068512987037a01e8fad980432"
  license "MIT"
  head "https://github.com/bcoin-org/bcoin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bcoin"
    rebuild 1
    sha256 mojave: "0076920b0f949d179e6b0defff2f09e19d0c3518388b07c77ac46de162f9d082"
  end

  depends_on "python@3.10" => :build
  depends_on "node@16"

  def node
    deps.reject(&:build?)
        .map(&:to_formula)
        .find { |f| f.name.match?(/^node(@\d+(\.\d+)*)?$/) }
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", PATH: "#{node.opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const bcoin = require('#{libexec}/lib/node_modules/bcoin');
      assert(bcoin);

      const node = new bcoin.FullNode({
        prefix: '#{testpath}/.bcoin',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{node.opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.bcoin")
  end
end
