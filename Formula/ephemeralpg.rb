class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.2.tar.gz"
  sha256 "c07df30687191dc632460d96997561d0adfc32b198f3b59b14081783f4a1b95d"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ephemeralpg"
    sha256 cellar: :any_skip_relocation, mojave: "52682ed55c5b62766213a2df0c7b742870642309784ad0ef1749ec9d63f0db62"
  end

  depends_on "postgresql"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
