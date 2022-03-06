require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.9.4.tgz"
  sha256 "19d04aba527e143aba8449f06c9c7812f01feae70bf7f67a539ebe890831f4f7"
  license "MPL-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cdktf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a81514454982fb03f818d902ae4b41b83bd4e62250cb412069b073759c7f450a"
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
