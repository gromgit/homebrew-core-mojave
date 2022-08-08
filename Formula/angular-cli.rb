require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.1.1.tgz"
  sha256 "0a136f126fa14387f077f9f1c413c9c3fb705ee6a3635e207b280413d2ed96b8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli-14.1.1"
    sha256 cellar: :any_skip_relocation, mojave: "ba6043b269f8d1a028fc8f1af013a3e2320677711dfb97e52da5be398c34dfca"
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
