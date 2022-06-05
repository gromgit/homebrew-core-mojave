class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.35/vrpn_07.35.zip"
  sha256 "06b74a40b0fb215d4238148517705d0075235823c0941154d14dd660ba25af19"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vrpn"
    sha256 cellar: :any, mojave: "c5fc348b2f0da97e1592ccf725ed8445da8e1c725de2600aae6467a06412cadd"
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
                            "-DVRPN_BUILD_CLIENTS:BOOL=OFF",
                            "-DVRPN_BUILD_JAVA:BOOL=OFF"
      system "make", "install"
    end
  end
end
