class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git",
      tag:      "5.0b",
      revision: "f7a7847ea2d4764d9a0a211ba6559fa98e8dbee6"
  version "5.0b"
  head "http://hgm.nubati.net/git/fairymax.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fairymax"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0c573f61797a9bd24045ef14d65860b8602af16524af8f7fcfa16bf5b63b6b2d"
  end


  def install
    system "make", "all",
                   "INI_F=#{pkgshare}/fmax.ini",
                   "INI_Q=#{pkgshare}/qmax.ini"
    bin.install "fairymax", "shamax", "maxqi"
    pkgshare.install Dir["data/*.ini"]
    man6.install "fairymax.6.gz"
  end

  test do
    (testpath/"test").write <<~EOS
      hint
      quit
    EOS
    system "#{bin}/fairymax < test"
  end
end
