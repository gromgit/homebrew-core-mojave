class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.0/proteinortho-v6.1.0.tar.gz"
  sha256 "4c087cbfd91051136df808a679694ab2ada3c266c175b4187689f302e8ccf8ac"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proteinortho"
    sha256 cellar: :any, mojave: "9cb4c6280b4719eeea514193ea0ed04fc9ba0ce215659dff2663f0e369f03c7b"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
