class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.6.tar.gz"
  sha256 "c588d1cb53ccea3e592f99402b14c2f4367b349ecef8e17b6d391df146bc8ba4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spot"
    rebuild 1
    sha256 cellar: :any, mojave: "ea9c15843451c61d4893eb79a2869d03a9e8e07794b59935342fd2ea1bd2b065"
  end

  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
