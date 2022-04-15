require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.8.tgz"
  sha256 "a1b98f21b4a95306ef9e74d59c6499fd746fee9dc004aed3b82dd894cec2e93f"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/terrahub/latest"
    regex(/"version":\s*?"([^"]+)"/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terrahub"
    sha256 cellar: :any_skip_relocation, mojave: "6cf0027c82e668b3eff48779750e643a62069f5f03db780e2c54989c2030ab73"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
