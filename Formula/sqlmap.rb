class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.9.tar.gz"
  sha256 "bccf1bea6ce44777a860ecbcaa83773889de023aeb51266cdbe961b7dc7732ba"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sqlmap"
    sha256 cellar: :any_skip_relocation, mojave: "217f12ba6edd1b6cbc0c2b6c0388d647e0e2f1389d8021f55491ac8824d131ef"
  end

  depends_on "python@3.10"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
