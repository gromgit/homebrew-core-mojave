require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.12.0.tar.gz"
  sha256 "135170962f8b1ae9129e36e0a57d09509105846f0b193dd0d29a33d43a0234b5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serverless"
    sha256 cellar: :any_skip_relocation, mojave: "abcf8ddce14851a3194a9b1d8a60716828a0c5baf5d660d3da389e992bfd547a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
