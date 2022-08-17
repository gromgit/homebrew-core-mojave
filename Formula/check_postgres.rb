class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.25.0.tar.gz"
  sha256 "11b52f86c44d6cc26e9a4129e67c2589071dbe1b8ac1f8895761517491c6e44b"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/bucardo/check_postgres.git", branch: "master"

  livecheck do
    url "https://bucardo.org/check_postgres/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/check_postgres"
    sha256 cellar: :any_skip_relocation, mojave: "1e5d5939f4e5fe39416e7ca38959cf0898c437247df83c27c90ceb12612b6182"
  end

  depends_on "libpq"
  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"

    mkdir_p libexec/"bin"
    mv bin/"check_postgres.pl", libexec/"bin/check_postgres.pl"
    inreplace [libexec/"bin/check_postgres.pl", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"

    (bin/"check_postgres").write_env_script libexec/"bin/check_postgres.pl", PATH: "#{Formula["libpq"].opt_bin}:$PATH"

    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert_match "POSTGRES_CONNECTION CRITICAL", output
  end
end
