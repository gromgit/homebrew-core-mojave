class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.19.tar.xz"
  sha256 "13f35abc0782c7453da22602128eb93fa645039d92cd5ab3c528ae9e6032cd67"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/subnetcalc"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c37264918cb97ce1d47856f5e3f031bbbbc1400d182350bba969053a103bfae1"
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
