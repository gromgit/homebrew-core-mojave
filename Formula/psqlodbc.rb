class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-13.02.0000.tar.gz"
  sha256 "b39b7e5c41fd6475c551112fa724bf57c4a446175ec4188a90e2844cc1612585"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/odbc/versions/src/"
    regex(/href=.*?psqlodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/psqlodbc"
    sha256 cellar: :any, mojave: "4581f12c75664fade03412840b3c66f1935016e7fc523f774e91625507297600"
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
