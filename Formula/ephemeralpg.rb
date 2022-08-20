class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.2.tar.gz"
  sha256 "c07df30687191dc632460d96997561d0adfc32b198f3b59b14081783f4a1b95d"
  license "ISC"
  revision 1

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ephemeralpg"
    sha256 cellar: :any_skip_relocation, mojave: "6dd1e2dc0ea2cb35b966d3e19bdc77a19917434556f970bf78e2ffc4e5096841"
  end

  depends_on "libpq"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
