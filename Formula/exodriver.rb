class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.6.0.tar.gz"
  sha256 "d2ccf992bf42b50e7c009ae3d9d3d3191a67bfc8a2027bd54ba4cbd4a80114b2"
  license "MIT"
  head "https://github.com/labjack/exodriver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exodriver"
    rebuild 1
    sha256 cellar: :any, mojave: "d85e58b97531e8c172e4e7ffc26e97a1424940d773f4d83af8a367e3cd169ef4"
  end


  depends_on "libusb"

  def install
    system "make", "-C", "liblabjackusb", "install",
           "PREFIX=#{prefix}", "RUN_LDCONFIG=0", "LINK_SO=1"
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    system "make", "-C", "examples/Modbus"
    pkgshare.install "examples/Modbus/testModbusFunctions"
  end

  test do
    output = shell_output("#{pkgshare}/testModbusFunctions")
    assert_match(/Result:\s+writeBuffer:/, output)
  end
end
