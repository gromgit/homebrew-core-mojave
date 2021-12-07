class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.28.0.tar.gz"
  sha256 "39b77f35a0d8d9b573436d65a2ca8cc36ad835956a00df64d524fed02f4a40a5"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flarectl"
    sha256 cellar: :any_skip_relocation, mojave: "a615cdd0bb4c171338a4f12c5892d0232296f86fa8f30dc68b9efdd03aa24f2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
