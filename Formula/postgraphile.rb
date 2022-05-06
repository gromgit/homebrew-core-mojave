require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema 🐘"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.12.10.tgz"
  sha256 "83c7045124f3d0f60f6adba0b8d6c174af2a50b05b619387c4012931120d3283"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/postgraphile"
    sha256 cellar: :any_skip_relocation, mojave: "a8e8cdbc3bd54f72d58128c00481e31e7046aec333000c8feb2d27c0928d5a8f"
  end

  depends_on "node"
  depends_on "postgresql"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql"].opt_bin
    system "#{pg_bin}/initdb", "-D", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres", "-D", testpath/"test")
    end

    begin
      sleep 2
      system "#{pg_bin}/createdb", "test"
      system "#{bin}/postgraphile", "-c", "postgres:///test", "-X"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
