require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.3.0.tgz"
  sha256 "4f5389a6be4c83f08e22199788b7a228e5013d57d2146c80cb4bc2249f4e1bbe"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netlify-cli"
    sha256 cellar: :any_skip_relocation, mojave: "235315ff793c5f85da6e9d1b124cdde8afb6c923c4e1c058fc0af677b7f2fbcb"
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
