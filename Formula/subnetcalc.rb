class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.20.tar.xz"
  sha256 "5bc3a2ca7542d9ba0903632c9fc9d032e1929595dde7248e9d49b58a4d6556ba"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/subnetcalc"
    sha256 cellar: :any_skip_relocation, mojave: "88ef58924ee6de293ca555f00a042b2a1c1210d5343a97907fcaebe3a2813cd8"
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
