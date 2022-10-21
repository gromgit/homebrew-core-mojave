class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "35a2d165ae6e1f39033ef7ab9ef3b0b205dc1b6b5583912a082297e93ad1c8ab"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sqlcmd"
    sha256 cellar: :any_skip_relocation, mojave: "bc95778e13bbeefa2d59c409de4bfb987db13b76ecfc87834859a98576902361"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/sqlcmd"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out
  end
end
