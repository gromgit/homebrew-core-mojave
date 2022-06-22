require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.5.0.tgz"
  sha256 "cf6a433519783e7a5448b1405814d96e84f897295b7d8348cfccb87c55d53a58"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netlify-cli"
    sha256 cellar: :any_skip_relocation, mojave: "52b0eba12dea2c0d46dc34383123aee87c672e1ea04dd9d289ecfafb8bbd25f8"
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
