class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.4.1.tar.gz"
  sha256 "f8bf221bed765447b809c85f1c3dffaf6b241362f745a80906f8e98869e11edd"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rover"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3ff8ab85d7ea594f48a4e38faa402c704acc2728c9c44280fb8cddbff8fa8471"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
