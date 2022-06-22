class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://github.com/pothosware/SoapyRTLSDR/archive/soapy-rtl-sdr-0.3.3.tar.gz"
  sha256 "757c3c3bd17c5a12c7168db2f2f0fd274457e65f35e23c5ec9aec34e3ef54ece"
  license "MIT"
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/soapyrtlsdr"
    sha256 cellar: :any, mojave: "71bb5f06efd962cd43f2ac752b6f0756d01a894b7fe060dcf44fdfbcc5b20860"
  end

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'rtlsdr'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=rtlsdr")
  end
end
