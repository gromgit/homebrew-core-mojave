class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.31.1.tar.gz"
  sha256 "42dff476e0cf40e570851eb9c7b3665a177e5632409fb8c980a708f67775d508"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flow-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "59ce89db3b34ae8c215e11db43b907304fde4efb074effe9b11d614b05e1367e"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
