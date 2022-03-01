class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.03.tar.gz"
  sha256 "9684bb1562bfe14559007401f52975554373546d3290a19618ee71d709bce76e"
  license "GPL-3.0-or-later"
  head "https://github.com/lonsing/depqbf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/depqbf"
    rebuild 1
    sha256 cellar: :any, mojave: "eb1a4a3dc828aee7437a83e95842a5595981b417078b15a707c503a31bd4dcda"
  end


  resource "nenofex" do
    url "https://github.com/lonsing/nenofex/archive/version-1.1.tar.gz"
    sha256 "972755fd9833c9cd050bdbc5a9526e2b122a5550fda1fbb3ed3fc62912113f05"
  end

  resource "picosat" do
    url "http://fmv.jku.at/picosat/picosat-960.tar.gz"
    sha256 "edb3184a04766933b092713d0ae5782e4a3da31498629f8bb2b31234a563e817"
  end

  def install
    (buildpath/"nenofex").install resource("nenofex")
    (buildpath/"picosat-960").install resource("picosat")
    system "./compile.sh"
    bin.install "depqbf"
    lib.install "libqdpll.a"
    if OS.mac?
      lib.install "libqdpll.1.0.dylib"
    else
      lib.install "libqdpll.so.1.0"
    end
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
