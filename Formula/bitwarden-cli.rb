require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.6.2.tgz"
  sha256 "9d6f7e3289c1798438079e4f43d479124ff8d345c0675313304af5707c9f7e2a"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bitwarden-cli"
    sha256 cellar: :any_skip_relocation, mojave: "003e6c7ed8600eb01d3b5a01fea06a9b42955c76dc790abe73c2f3fa9e9d5a12"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
