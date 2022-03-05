require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.14.0.tgz"
  sha256 "8aff6b0549f9c3713695582c0b8ab36d2e37d441d1d7fd0fd413ea769e8aaa39"
  license "MPL-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fauna-shell"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "56a134301295590a3d08393d84dd069974ae39de5232ac4167885e944bb95c16"
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
