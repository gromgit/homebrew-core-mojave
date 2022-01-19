require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-1.0.0.tgz"
  sha256 "8a8ef9d2166ba490066cff47f1b78ef1649daa0daa3ab294ea768bccda9bb3a3"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eleventy"
    sha256 cellar: :any_skip_relocation, mojave: "f720678901a0dbeb777257f8ff33ee6eb45029646bf0a2b6d063a0d978536503"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
