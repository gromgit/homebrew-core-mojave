class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2021.03.1.tar.gz"
  sha256 "84a9aef6fe2666744dc1a17ba5adb1d039f8038ffab30e9018dcfae312eab5be"
  license "GPL-2.0-or-later"
  head "https://github.com/mossmann/hackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hackrf"
    rebuild 1
    sha256 cellar: :any, mojave: "40b907559120938ec076e07600a01d31e776b7cf1266b594a0c27e7dc624e5e0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    cd "host" do
      args = std_cmake_args

      if OS.linux?
        args << "-DUDEV_RULES_GROUP=plugdev"
        args << "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
      end

      system "cmake", ".", *args
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
