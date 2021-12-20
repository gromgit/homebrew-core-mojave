class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ktoblzcheck"
    sha256 mojave: "43f68d0b855c0d6e314e2f87dcedb58b87e2b7d7cb49db1be35184c11b002976"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
