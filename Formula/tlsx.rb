class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.7.tar.gz"
  sha256 "82b54e89ff5c73f5a8536443466c897a6b0bb5ee50ea101390c10211bdf4f00e"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tlsx"
    sha256 cellar: :any_skip_relocation, mojave: "95d76f930b1c8168f994e19110e55c52002d74294199871cb4e6f1dc6c0031ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
