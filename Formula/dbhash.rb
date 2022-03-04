class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380000.zip"
  version "3.38.0"
  sha256 "77c53d4812cad7856f5f1a1e07d2a2c2a3444d26a965274279f8dd9faa6ff480"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbhash"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3e3c96935e2887abae65199c7cf057f24d7e4c2b31220b859cf658e9047f76df"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
