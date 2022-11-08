require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.3.12.tgz"
  sha256 "b4f2f11e3a8b95cd417a75142d7aaf8b22c7949c60133dc0a14b65c2c7725f33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31307d18aa0bf23ffddd4fc098bf41f65de46e3cdfb39ff4f4048af31ab19650"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
