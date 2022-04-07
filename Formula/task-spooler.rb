class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.2.tar.gz"
  sha256 "f73452aed80e2f9a7764883e9353aa7f40e65d3c199ad1f3be60fd58b58eafec"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/task-spooler"
    sha256 cellar: :any_skip_relocation, mojave: "6b38d55206eaaf78cd8593b6d624a39f7689d88f1af501754df090d2ca4818af"
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
