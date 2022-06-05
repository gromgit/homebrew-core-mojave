require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.2.0.tgz"
  sha256 "0e0d1c3d0869a0b369dbc4448df2f10d1f450518c3568b423ac0d33c004a658b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nativefier"
    sha256 cellar: :any_skip_relocation, mojave: "58c9e5563632acef6feda9b93f81cb6f3bd9904eb8bd35674a6bf5b0c1bae6ce"
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
