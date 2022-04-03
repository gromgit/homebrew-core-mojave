require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-6.1.0.tgz"
  sha256 "c3cbaa3a4d72ccadf1125762895c2714e8474099c9da73c60bd766f17f92fac4"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hexo"
    sha256 cellar: :any_skip_relocation, mojave: "3b956bafe14f1523fd2dca05cdcc491bb12053d2f50cdbca1c398a0f8db34f61"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
