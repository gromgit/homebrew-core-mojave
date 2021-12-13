class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.6.1.tar.gz"
  sha256 "a862a209d696becff915a77512e6a8c22f92d73480a45cc12273d9ad1db60d23"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openfpgaloader"
    sha256 cellar: :any_skip_relocation, mojave: "68f00681cfa8f0e0fc347ef7f1261064d5f4e85253442269c9d1dd6b843a227d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

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
