class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.7.1.tar.gz"
  sha256 "7b6ca0f403b092102c42ca56daa9e1f3e64d945de0a4c298e3f5cc092f7c3fa6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    sha256 cellar: :any_skip_relocation, mojave: "63841481283379970384229dbe430c1f85329311ad21415185c3d7d4a64a7bae"
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
