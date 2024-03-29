class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.12.0.tar.gz"
  sha256 "28ec1451f0527ad40c1a4c92547966ffef96813528c8b184a665f03ecbb508bc"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hidapi"
    rebuild 1
    sha256 cellar: :any, mojave: "ad3adf33149d9c8357ceed01538591d550de4b0441562cee20a6c0eec8d5c5ad"
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
    flags << if OS.mac?
      "-lhidapi"
    else
      "-lhidapi-hidraw"
    end
    flags += ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
