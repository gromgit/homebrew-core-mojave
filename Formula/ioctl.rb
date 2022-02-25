class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.4.tar.gz"
  sha256 "1a54d59db80aee21cd5925bd8ef0829b91cd40b45f1259c6127388d35c5b9272"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    sha256 cellar: :any_skip_relocation, mojave: "21989d288614f4e5035db867cb15881b14c4651124629680ff5956ca9c8f80f2"
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
