class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.6.tar.gz"
  sha256 "1728c341b147388fa8e60784c4b3895391be25f1e2e1b1cbb734329be7603693"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gau"
    sha256 cellar: :any_skip_relocation, mojave: "6221cec376bf0285d26ca8fc71cd49101a344c83f0e262a8edd670deb19d2865"
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
