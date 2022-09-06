class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.6.1.tar.gz"
  sha256 "e1caf2b7130e4d6c7190582707304c417f47c84efc2e6f79968811b30c86bc6f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "acd916bacb44c60585320a875c77f72fcdf1a1159c9f99049e5d93ed8ccade2b"
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
