class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://www.exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.16.tar.gz"
  sha256 "46e072d5d45c9fd3d5b268523501bbea0ad016232b2d3f366a7aad0b1e7b3f71"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?minised[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minised"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "66ad94431174c33887ab56faa2b70a83c9e59bcb76991943836b4f50786dbf38"
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
