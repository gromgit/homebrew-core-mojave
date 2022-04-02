class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.9.tar.gz"
  sha256 "3a83671c77e6040ada89f8a53e7cca566b67cc9a2b2c788d2f1d782f365adbf4"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gau"
    sha256 cellar: :any_skip_relocation, mojave: "4080dd071374847b9e582c4b6d33c2f6da1fff7b931d2c80c8bd1f813e25dcc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
