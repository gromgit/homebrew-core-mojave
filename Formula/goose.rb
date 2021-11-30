class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.4.1.tar.gz"
  sha256 "13cac5b591ab4d4946c739e73b74aa6dfb17a05ad51fc63ae34615a0edf31600"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "74b242bab82fd3e20d08a4e4221318b23662cedfebee2d15f87493fde532149f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
