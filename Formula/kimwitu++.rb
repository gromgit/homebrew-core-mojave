class Kimwituxx < Formula
  desc "Tool for processing trees (i.e. terms)"
  homepage "https://www2.informatik.hu-berlin.de/sam/kimwitu++/"
  url "https://download.savannah.gnu.org/releases/kimwitu-pp/kimwitu++-2.3.13.tar.gz"
  sha256 "3f6d9fbb35cc4760849b18553d06bc790466ca8b07884ed1a1bdccc3a9792a73"

  livecheck do
    url "https://download.savannah.gnu.org/releases/kimwitu-pp/"
    regex(/href=.*?kimwitu\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kimwitu++"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f7cfecafd85acff91cea515cfa3759395379275b8fcc06ae152bef2b0be0e8a6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end
end
