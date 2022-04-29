require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-1.0.1.tgz"
  sha256 "2740d2c85b97f10ea3ce04fd41f860072186fb3dd2d67f5de54f0236cf0614c2"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eleventy"
    sha256 cellar: :any_skip_relocation, mojave: "c934fac5e288fe6ff4c224a731926f6562469bf4537dad644ee643053aebef22"
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
