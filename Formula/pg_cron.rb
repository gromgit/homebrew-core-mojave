class PgCron < Formula
  desc "Run periodic jobs in PostgreSQL"
  homepage "https://github.com/citusdata/pg_cron"
  url "https://github.com/citusdata/pg_cron/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "f50792baa7105f7e5526ec0dca6d2328e4290131247c305cc84628cd864e9da2"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pg_cron"
    sha256 cellar: :any, mojave: "7d2e76d2ae42c26b4e1fb5b097404636f6621355a1c8c6fd9a884c13c2cd296f"
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
