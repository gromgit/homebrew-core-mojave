require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.15.0.tgz"
  sha256 "ac7339ae28b4815958e19079221c18af0704825243b6cbdd23c5e1120df955c6"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fauna-shell"
    sha256 cellar: :any_skip_relocation, mojave: "e7c0a86f3e4be2a7909b3905993b510d12147dc0a6376d3756c1d7e8f36794ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end
