class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.3.tar.gz"
  sha256 "783c72fb8901b9cb0f33c25aa98079c4f5e21657d02c4379bb5c9303c38448af"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioctl"
    sha256 cellar: :any_skip_relocation, mojave: "9265ed9c14ac66016bb180029e4e77751cdd97d41d858d56830e25682961dabd"
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
