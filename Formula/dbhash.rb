class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3390000.zip"
  version "3.39.0"
  sha256 "b3585f37dd106dbb3d46c8c17a2d275f9a4b87df8c4509bd2d6a5b40032426e6"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbhash"
    sha256 cellar: :any_skip_relocation, mojave: "4eea60e612fc13e74681788e7e19c7f2e8900dbb850efac9bfbbf9d86988947d"
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
