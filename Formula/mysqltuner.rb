class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f5a8ef9486977dd7e73ef5d53a1a0bf7f3cc7bf9ba9f9f4368454352cd0f881a"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mysqltuner"
    sha256 cellar: :any_skip_relocation, mojave: "dde5020c41fd2f0a91dc626bff3a72649f78498d5bdcd7098dc60ef7cb323381"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system "#{bin}/mysqltuner", "--help"
  end
end
