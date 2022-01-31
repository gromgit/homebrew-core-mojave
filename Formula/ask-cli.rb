require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.26.0.tgz"
  sha256 "62bdf53a6113d06cf65d476ce03ac85a9d0ee5af273087e45b8c2ee1e7c70c72"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ask-cli"
    sha256 cellar: :any_skip_relocation, mojave: "c2e89d8826162c02ed7f379f8474faf9c7c950cc523ba08020d6df40dbc01f0c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
