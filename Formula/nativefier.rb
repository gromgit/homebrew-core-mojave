require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.1.1.tgz"
  sha256 "bd9f8296595cd2a1453dadfc3dcede35e99fc21cb05bd7e7b610d6759400789e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    sha256 cellar: :any_skip_relocation, mojave: "a47917ae666ec5cec6bb7dc52b43e383a2ea66a6c87f37d8fa891b59a0ab74e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
