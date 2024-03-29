class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.7.0.tar.gz"
  sha256 "704feecc502f08b69e53135df3125b88f6b94174c51448c8c5013dba7389efa3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fa927ed99e94b91130cb1d05bf2d4ea9a194e0d8bc38132aaeffa19cf8a6e30c"
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
