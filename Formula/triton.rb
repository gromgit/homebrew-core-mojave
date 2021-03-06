require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.1.tgz"
  sha256 "e325641d2ba183c484597e196ee74ecf67e6a0bcb459dd7ef49d23c509eec984"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/triton"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "401462af88eb80a1d0ab0c15ee1d22bd98215bdfe0ed7c970671a4fd2e19f9f2"
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
