require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.2.tgz"
  sha256 "b42b23d41b5ae2c36b21f091d1473546d538a7cbe26cd1a456b415e20cc51eb8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angular-cli"
    sha256 cellar: :any_skip_relocation, mojave: "0e006e40adb975175319d8ee7acb7f8b25dd5203d8ea419dfeb1e1e09f2cf91c"
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
