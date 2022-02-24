class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.11.tar.gz"
  sha256 "23f9a917f160c1e2be9d7bd6ee4a2925799139225695337ab4a733f7157555d0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sqlx-cli"
    sha256 cellar: :any_skip_relocation, mojave: "81d620a9730c4b44fb99c05ef3ed35e656f577526d60b9b50d33fcad29d06320"
  end

  depends_on "rust" => :build

  def install
    cd "sqlx-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
