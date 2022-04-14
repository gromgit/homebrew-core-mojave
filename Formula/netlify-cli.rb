require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.16.0.tgz"
  sha256 "48efe2134b83c1bf0970d295026cc0b25066ed3c9cac2b4dbb449b7ecf73ecb4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netlify-cli"
    sha256 cellar: :any_skip_relocation, mojave: "e920afcb40a3daa5a51ff1b6cb478610206488a5db9b7c6b40a2ad06f5598648"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
