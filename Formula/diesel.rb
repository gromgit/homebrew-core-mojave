class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.0.tar.gz"
  sha256 "5a95e7717c32e762963db90a32f49b79ab799987434c41b7d982c85334ecc2bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/diesel"
    sha256 cellar: :any, mojave: "366a9cd9d1a6b887446298f064d6e9340b0502aee54bb12b2c531cffecdfd6c0"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

    cd "diesel_cli" do
      system "cargo", "install", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"diesel", "completions", "bash")
    (bash_completion/"diesel").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"diesel", "completions", "zsh")
    (zsh_completion/"_diesel").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"diesel", "completions", "fish")
    (fish_completion/"diesel.fish").write fish_output
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
