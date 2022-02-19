class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.3.tar.gz"
  sha256 "d91ba41397563ddaae02f93bae0602e9adc1686c681d1cef91742dac71b005f4"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rover"
    sha256 cellar: :any_skip_relocation, mojave: "3cea1790841d6f3f0fd06dee0369bc72e96a9aa32b1440515473f17c3255400e"
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
