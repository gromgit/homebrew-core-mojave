class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.1/proteinortho-v6.1.1.tar.gz"
  sha256 "04fad661070d33d42df542ecf04db07e496b1efcc29bdd5fd7cdefafaa2dd0b1"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proteinortho"
    sha256 cellar: :any, mojave: "7ffc4b4983a143a839ef05731f462d13e31de86834041823cac8e3f731640ce2"
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
