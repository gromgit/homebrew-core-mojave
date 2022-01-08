require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.25.0.tgz"
  sha256 "ad4c1056e0f9828c08a0ff39700a38246d7fac6ef703b545d56fbd6784bc3861"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ask-cli"
    sha256 cellar: :any_skip_relocation, mojave: "bf89724630d9edcce5f9e78e24a9f9b8310180ab114064cc26b56f097447ad7a"
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
