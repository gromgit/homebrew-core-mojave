require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.8.0.tgz"
  sha256 "3fe3f0df9cab64c1775b507bc01556bd351173caffe0961f4ef3194c7630da09"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitmoji"
    sha256 cellar: :any_skip_relocation, mojave: "095273ec72a429e5d7bf4ad9512f17744a0a83a23a365fee9529ed20c9f04b76"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
