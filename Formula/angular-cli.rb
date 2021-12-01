require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.3.tgz"
  sha256 "ae7b1ec8c1ca14313cd1884f1a3642dc33b291496de6984bac63fa2d294fd4dd"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "88fd8fa1e687db117b1eed3ac74b27b42b5d05b7fbf54a3c32867681ad5f8815"
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
