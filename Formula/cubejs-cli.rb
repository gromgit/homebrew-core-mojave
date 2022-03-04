require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.28.tgz"
  sha256 "6b05a19a711730d3c689fbd5d7b45d6c88dae1e4133c3cc73b87079a428551a3"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cubejs-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "544b9e21d5b0a17a8ef9af37ee2c75e1e588813fc37694f6cfbbcc9d3a7d9bf3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
