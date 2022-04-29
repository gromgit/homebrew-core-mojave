class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.2.tar.gz"
  sha256 "c07df30687191dc632460d96997561d0adfc32b198f3b59b14081783f4a1b95d"
  license "ISC"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ephemeralpg"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "61b58fb373ec59b7cf8fe37132a309ea97b1c1388ef8d0cdc3dbeb592b6a8f9f"
  end

  depends_on "postgresql"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
