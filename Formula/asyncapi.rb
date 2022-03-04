require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.14.1.tgz"
  sha256 "cbd04cbd5450f06822b3e7b4faece948b24e73f96693cfff4fd49cf5033e46ea"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/asyncapi"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2a9d79820829d8a3df1dd53a4fad3db68b929ad000670c6d5612861aa28e2782"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
