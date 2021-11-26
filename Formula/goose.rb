class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.3.1.tar.gz"
  sha256 "95ecd4176dd86126d56f23d8dccbc37550b0ee1c7f22004ee5bc5a4f3547856c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "897d1c65ed69fe9c6850cca278eaadcf49bf0a02d76d654255debe116ab1b6a7"
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
