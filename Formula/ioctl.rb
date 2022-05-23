class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.8.0.tar.gz"
  sha256 "0ff566ca690801e5bdce8d24532e23a5a6e7f1969ead1e6f519651b9fabac352"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    sha256 cellar: :any_skip_relocation, mojave: "ff0aeb87c577ba77d991b41bd1f4c07cf85d8cd09f4b6d891e25ab3c678ca0bc"
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
