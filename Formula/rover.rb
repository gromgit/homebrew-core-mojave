class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.8.tar.gz"
  sha256 "e95c5f6f01efe4381334cbd2637bf9f8c849855b0705a87cf4d5c5103bc4ecdb"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rover"
    sha256 cellar: :any_skip_relocation, mojave: "2f14654ef8b2f507b93a2982dd120f777c857db858d040ee5b0a242d037b982c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
