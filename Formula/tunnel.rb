class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://github.com/labstack/tunnel-client"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tunnel"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "b8ee1eb6e752b6029b2ecde79e64147403189a570a073c5892354c48fc8ac641"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    assert_match "you need an api key", shell_output(bin/"tunnel 8080", 1)
  end
end
