require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.0.tgz"
  sha256 "21943e63242e8e39a8159d76fe4f53eed3a441af20d299276c09a4b980809444"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cdktf"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5b5e64bc737f31968a546d579155c4ad8a2a5ec8edb9298dd18b66a0a37e0e41"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
