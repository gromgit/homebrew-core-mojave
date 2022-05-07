class Wb32DfuUpdaterCli < Formula
  desc "USB programmer for downloading and uploading firmware to/from USB devices"
  homepage "https://github.com/WestberryTech/wb32-dfu-updater"
  url "https://github.com/WestberryTech/wb32-dfu-updater/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2b1c5b5627723067168af9740cb25c5c179634e133e4ced06028462096de5699"
  license "Apache-2.0"
  head "https://github.com/WestberryTech/wb32-dfu-updater.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wb32-dfu-updater_cli"
    sha256 cellar: :any, mojave: "c1b3b43735814346df573cd124c4ed702fdc4444ad381163d58984f6b2ad9492"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No DFU capable USB device available\n", shell_output(bin/"wb32-dfu-updater_cli -U 111.bin 2>&1", 74)
  end
end
