require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.1.tgz"
  sha256 "e325641d2ba183c484597e196ee74ecf67e6a0bcb459dd7ef49d23c509eec984"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/triton"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "6062ab366afb195d7dfdad9a4cde4a707e3f681b55f2b3c8cc5835dd0708f86e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
