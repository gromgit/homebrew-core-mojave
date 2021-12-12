class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/1.3.1.tar.gz"
  sha256 "49ef54c474bd2e07c31516ac94a65d532c95499002a1ce0565d14702bc960a99"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/akamai"
    sha256 cellar: :any_skip_relocation, mojave: "1bc75ab2eca2e2d78821193174aa6d7c84f0bff5679a6aa0b26e312427d51408"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
