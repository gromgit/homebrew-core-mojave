require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.15.0.tgz"
  sha256 "0cc99d0715d4e496f9a7ad442fad53a722eae498cf789e6127b4b2c288c5318c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netlify-cli"
    sha256 cellar: :any_skip_relocation, mojave: "9e57c0d2f6ddb2756f777af78cc6ebbbc4670a8d205fedb2555c5fc05776afc6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
