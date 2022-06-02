require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.7.tgz"
  sha256 "b8641f8f270861023a0c37cc3f445969d27580687a1fbd8ccf822f55a48b8637"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    sha256 cellar: :any_skip_relocation, mojave: "81bc640d9d1185b1c1e1e361ed51fd4f5c4f73d859502e22be7272cdb8609606"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
