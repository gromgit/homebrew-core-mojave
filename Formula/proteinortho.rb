class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.35/proteinortho-v6.0.35.tar.gz"
  sha256 "1aa4a887d82a1074f1032d5a56858b35505d4c9937080a4f366fbdcc83e483d3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proteinortho"
    sha256 cellar: :any, mojave: "f5f1f584265e82b9d76cc164f779f2d5e0bd83dcfba86bc73c613ca8c8e5a714"
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
