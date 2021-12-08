class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.1.tar.gz"
  sha256 "89505eb7fe84a718486c38d8326f37676691cfa8c86a55692af30cb117dfa8e6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "52e894383721e914671bd6f83bed2aa44560501c642d37c7f7b3b9c5708fcc40"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
