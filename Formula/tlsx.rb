class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.6.tar.gz"
  sha256 "79c663951053e866d0ad28a61bc218054e80611c29b4de6680d4eb7448c67593"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tlsx"
    sha256 cellar: :any_skip_relocation, mojave: "b92d4c3ad858acbfa9df414dbe535d4f43609dd72564ba77122d388a2255c62c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
