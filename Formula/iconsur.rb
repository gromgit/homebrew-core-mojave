require "language/node"

class Iconsur < Formula
  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.7.0.tgz"
  sha256 "d732df6bbcaf1418c6f46f9148002cbc1243814692c1c0e5c0cebfcff001c4a1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iconsur"
    sha256 cellar: :any_skip_relocation, mojave: "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
