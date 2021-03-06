class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mrbayes"
    rebuild 2
    sha256 cellar: :any, mojave: "b65f1502c598c98170381c7b4a68fdac7129d5e20f86077671ba7d733ba502cc"
  end

  depends_on "pkg-config" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  def install
    system "./configure", *std_configure_args, "--with-mpi=yes"
    system "make", "install"

    doc.install share/"examples/mrbayes" => "examples"
  end

  test do
    cp doc/"examples/primates.nex", testpath
    cmd = "mcmc ngen = 5000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end
