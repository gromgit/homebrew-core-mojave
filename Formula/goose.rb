class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.1.tar.gz"
  sha256 "31dafd95b1f568ac35e686b85b36cdcaba5106098c4d57b5bdad7a584d15aaee"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goose"
    sha256 cellar: :any_skip_relocation, mojave: "86d1f0c2d613511d6d3c0668ab722418d78aef43ba5e8d925a22e172bef345af"
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
