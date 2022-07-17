class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.44.0.tar.gz"
  sha256 "16a247764906894bf740999b6063fc21eaac33e8615d33635336746726dd7881"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flarectl"
    sha256 cellar: :any_skip_relocation, mojave: "a4b75215efa2f3a381ea0f1a7ed95e656ac2ca840f1dd985a5d64475a1d1a629"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
