require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.5.tgz"
  sha256 "0ed74cee0870f2dc3b893d2e00aa962f7a00b4b0d94bf55b8a310db3e56ed8d2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    sha256 cellar: :any_skip_relocation, mojave: "dca97b1ec8936abfbdb5013e5efca4c7723e3ca4b38c3d226fa958b44d0ab230"
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
