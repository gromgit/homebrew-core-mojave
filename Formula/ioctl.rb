class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.8.1.tar.gz"
  sha256 "53b284a4829c2eba2defa8d03d12dbe81e3808cf91a31bbef591fd8e16f8c610"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    sha256 cellar: :any_skip_relocation, mojave: "2cb5f215afa2701fb5fef4c31657d63b7386f9608d4eedf5556cc11293173239"
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
