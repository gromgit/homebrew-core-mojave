require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.4.tgz"
  sha256 "b81c513a4a9fbbc6a43a61767f0fc91ae998588cef6ceb5398d5075b2eaad3d0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "64de5e489d7d120a0075e8f9310ddf30c0ea413cf03bca38bc92d60ff71a08e5"
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
