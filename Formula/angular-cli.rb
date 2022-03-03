require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.5.tgz"
  sha256 "0ed74cee0870f2dc3b893d2e00aa962f7a00b4b0d94bf55b8a310db3e56ed8d2"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ec8f9c004da4f9cc976d91335837f4865d9a67fd31a4b028a5ef94660e47d4cd"
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
