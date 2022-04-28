require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.14.tgz"
  sha256 "00df3dcc6e8b3a4dd7668934a20e60e6fc0c4269790192179388c928553a3f7e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bower"
    sha256 cellar: :any_skip_relocation, mojave: "f155eb229286bef7f21e55ada513c525913b38cc8db1d86a3b47fc7ee9a1f1fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
