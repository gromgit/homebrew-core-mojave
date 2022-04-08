class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://github.com/labstack/tunnel-client"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tunnel"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "48fb4ee67098a2f8743710b755ca2ad6bb44e53796f097c5f48e40432efc640d"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    assert_match "you need an api key", shell_output(bin/"tunnel 8080", 1)
  end
end
