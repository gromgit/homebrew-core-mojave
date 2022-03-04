require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.11.5.tgz"
  sha256 "acf83f6b17d3847aff784942386a45a23a512e0a7abcee347e4a9f2c6559c066"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/contentful-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7b8b421867cbb777a8fd1a2a90b42d6f6bbc455e379191c3bddff27511e8189f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
