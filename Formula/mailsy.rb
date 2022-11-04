require "language/node"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-3.0.8.tgz"
  sha256 "7de521c277029e4ad0b373b2a89310caff08afcb2cd861e50f2c8dfaa292e13c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mailsy"
    sha256 cellar: :any_skip_relocation, mojave: "58cfd912f0f7e92d70724b13ba62ce47464ece8078933e6f05614499e6502832"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Account not created yet", shell_output("#{bin}/mailsy me")
    assert_match "Account not created yet", shell_output("#{bin}/mailsy d")
  end
end
