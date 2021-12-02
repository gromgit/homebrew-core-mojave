class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.6.0.tar.gz"
  sha256 "0971db2302e704966d2e29b8d34e95f553cfd8f81e5ab70ec0533f03f219cf49"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

  # Fix incorrect version
  # https://github.com/trabucayre/openFPGALoader/pull/144
  patch do
    url "https://github.com/trabucayre/openFPGALoader/commit/efeb0d83c479200e359407245f82000ee4f33558.patch?full_index=1"
    sha256 "7f15ac39f8d079ebe8e73a763bbb4e3d7b441f74df1d5586dbe15af967d5fc33"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
