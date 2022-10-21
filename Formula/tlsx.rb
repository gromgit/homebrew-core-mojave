class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.8.tar.gz"
  sha256 "69725fd5bac23f9c4df1a0e5bb0d344153017bd1af772170162aeb6be0f7caac"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tlsx"
    sha256 cellar: :any_skip_relocation, mojave: "5674ecffaa8d89d17224f2e52069d4512943cda425dde732144017309e8423ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
