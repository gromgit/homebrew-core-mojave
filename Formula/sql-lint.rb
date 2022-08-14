require "language/node"

class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-1.0.0.tgz"
  sha256 "0ee3b71d812af3cc809829b663d9cd747996ec76e2b3e49fd3b7a5969398190e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sql-lint"
    sha256 cellar: :any_skip_relocation, mojave: "a1abb0bf427a60d56355852ba988e1f9eeb6161733094cf380e64a179abdbb46"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"pg-enum.sql").write("CREATE TYPE status AS ENUM ('to-do', 'in-progress', 'done');")
    output = shell_output("#{bin}/sql-lint -d postgres pg-enum.sql")
    assert_equal "", output
    (testpath/"invalid-delete.sql").write("DELETE FROM table-epbdlrsrkx;")
    output = shell_output("#{bin}/sql-lint invalid-delete.sql", 1)
    assert_match "missing-where", output
  end
end
