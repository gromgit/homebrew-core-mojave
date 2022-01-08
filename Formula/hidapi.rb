class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.11.2.tar.gz"
  sha256 "bc4ac0f32a6b21ef96258a7554c116152e2272dacdec1e4620fc44abeea50c27"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hidapi"
    sha256 cellar: :any, mojave: "ced8b673abb0036058181d51a78a020bef7cc21576089b27681fab8968c960c1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHIDAPI_BUILD_HIDTEST=ON"
      system "make", "install"

      # hidtest/.libs/hidtest does not exist for Linux, install it for macOS only
      bin.install "hidtest/hidtest" if OS.mac?
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}"]
    on_macos do
      flags << "-lhidapi"
    end
    on_linux do
      flags << "-lhidapi-hidraw"
    end
    flags += ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
