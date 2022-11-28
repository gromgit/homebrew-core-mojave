class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3400000.zip"
  version "3.40.0"
  sha256 "48550828142051293e179ffc6a8520f6fbfd82e1cdca78b93792f766cc89b8e2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbhash"
    sha256 cellar: :any_skip_relocation, mojave: "30c1127d31422e023a5c17d0f28b922de3d59be7d93960509aee8aa4cae56bb1"
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
