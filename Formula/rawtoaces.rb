class Rawtoaces < Formula
  desc "Utility for converting RAW to ACES"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  license "AMPAS"
  revision 10

  bottle do
    sha256 arm64_big_sur: "18f799bbe2b991360868a9464a74d4a724d4c80e7e2f467a3c4209e5958ce818"
    sha256 big_sur:       "817835b2dc5f277e666a86930b614a5deed5cc28f9feadcd09d4279a8e0350e2"
    sha256 catalina:      "bac6d5c1c94756f04bd9dd74093e0a4880bd558248771c2d33e7ad1818d8ded2"
    sha256 mojave:        "5ea5b07b5b3079318b9cf751664a2e822acff72c22eab7f7aa4673280ff9b241"
    sha256 high_sierra:   "de3645e35d6e0ba3ed7cf3890bc94f5009d426e39d682e767a3d861056aa6d18"
  end

  disable! date: "2021-01-06", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  # Fixes build with libraw 0.20.0
  # https://github.com/ampas/rawtoaces/pull/120
  patch do
    url "https://github.com/ampas/rawtoaces/commit/86d13a0b6d6a7058594258dfa6e1c5888d6a0b75.patch?full_index=1"
    sha256 "a0a897a6341783e7e4b4db117b37d54bd3197bb42e9c90b59dd74361137388d8"
  end

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
