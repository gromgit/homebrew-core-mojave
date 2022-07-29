class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.1.2.tar.gz"
  sha256 "2900ba86dfda01b5d8a90e1547f158feb134f6d2b757ff8fc77d96d290f72e4c"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gau"
    sha256 cellar: :any_skip_relocation, mojave: "4116c7f6af3a2f936af5eff6c8594cd78c2733c1dc6c2091b72e0d4f821e9dc1"
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
