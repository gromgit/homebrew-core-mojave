class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.2.tar.gz"
  sha256 "3b1bcb14ebda572b04b9bdf07574a449c84cb924905414e4d94e62837d22b628"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/srtp"
    rebuild 1
    sha256 cellar: :any, mojave: "d81880c6ad0514c9376b5e754f432f9f469d3b803821978dccd1a60462e6c316"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-openssl"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
