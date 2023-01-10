class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2022.09.1/hackrf-2022.09.1.tar.xz"
  sha256 "bacd4e7937467ffa14654624444c8b5c716ab470d8c1ee8d220d2094ae2adb3e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hackrf"
    sha256 cellar: :any, mojave: "e80df232ed899a8b3fdca39bafde465585657e8b42be2df631982675bb8120f4"
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
    pkgshare.install "firmware-bin/"
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
