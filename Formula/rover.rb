class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.5.4.tar.gz"
  sha256 "1728ee7eb5d87d9838972c1c441a7323315ded01c09d1edc7cf65c0e201a9fc9"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rover"
    sha256 cellar: :any_skip_relocation, mojave: "ca145e148760137bf06eb719e1bdac0caec1178e9be149b16ff93de7712e0da4"
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
