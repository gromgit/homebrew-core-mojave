class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "3652722ea98d94d8e27bf5e708dd7359f55a818a43550d046c5064c98876f1a8"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pg_cron"
    sha256 cellar: :any, mojave: "58ffbc913d0ce0565886183b2f7f5487411846c8a42ec97dadce5dd92750782e"
  end

  depends_on "postgresql"

  def install
    system "make"
    (lib/"postgresql").install "pg_cron.so"
    (share/"postgresql/extension").install Dir["pg_cron--*.sql"]
    (share/"postgresql/extension").install "pg_cron.control"
  end

  test do
    # Testing steps:
    # - create new temporary postgres database
    system "pg_ctl", "initdb", "-D", testpath/"test"

    port = free_port
    # - enable pg_cron in temporary database
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pg_cron'
      port = #{port}
    EOS

    # - restart temporary postgres
    system "pg_ctl", "start", "-D", testpath/"test", "-l", testpath/"log"

    # - run "CREATE EXTENSION pg_cron;" in temp database
    system "psql", "-p", port.to_s, "-c", "CREATE EXTENSION pg_cron;", "postgres"

    # - shutdown temp postgres
    system "pg_ctl", "stop", "-D", testpath/"test"
  end
end
