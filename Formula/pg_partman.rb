class PgPartman < Formula
  desc "Partition management extension for PostgreSQL"
  homepage "https://github.com/pgpartman/pg_partman"
  url "https://github.com/pgpartman/pg_partman/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "81ec4371985fd2f95ce4321b63371c0a308d476e57e6a4b7a5e23d73a5e4b218"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pg_partman"
    sha256 cellar: :any_skip_relocation, mojave: "c53dc161bed2724f1b86e223224c55236d6d55002c081f7d5d0e4e6c06b52542"
  end

  depends_on "postgresql"

  def install
    system "make"
    (prefix/"lib/postgresql").install "src/pg_partman_bgw.so"
    (prefix/"share/postgresql/extension").install "pg_partman.control"
    (prefix/"share/postgresql/extension").install Dir["sql/pg_partman--*.sql"]
    (prefix/"share/postgresql/extension").install Dir["updates/pg_partman--*.sql"]
  end

  test do
    # Testing steps:
    # - create new temporary postgres database
    system "pg_ctl", "initdb", "-D", testpath/"test"

    port = free_port
    # - enable pg_partman in temporary database
    (testpath/"test/postgresql.conf").write("\nshared_preload_libraries = 'pg_partman_bgw'\n", mode: "a+")
    (testpath/"test/postgresql.conf").write("\nport = #{port}\n", mode: "a+")

    # - restart temporary postgres
    system "pg_ctl", "start", "-D", testpath/"test", "-l", testpath/"log"

    # - create extension in temp database
    system "psql", "-p", port.to_s,
           "-c", "CREATE SCHEMA partman; CREATE EXTENSION pg_partman SCHEMA partman;", "postgres"

    # - shutdown temp postgres
    system "pg_ctl", "stop", "-D", testpath/"test"
  end
end
