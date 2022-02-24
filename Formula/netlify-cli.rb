require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.6.5.tgz"
  sha256 "88ca279ce6c49278fde81706fd31d50708243e210e3e9acccfdba30a3a08fbc2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netlify-cli"
    sha256 cellar: :any_skip_relocation, mojave: "ed2a98368b43971ada2183052c9f08203bcacefe9d071c3245ee090c1c279d03"
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
