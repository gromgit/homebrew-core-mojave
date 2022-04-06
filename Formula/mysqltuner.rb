class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.8.3.tar.gz"
  sha256 "9b8b1dff03550f03c659d2b850cb287d784f0d79f193c1d8a969516cc44738cb"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mysqltuner"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "393f0ac7cce07911ca779234b050a0fc034c944699e102162da7ffa850b95bb1"
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
