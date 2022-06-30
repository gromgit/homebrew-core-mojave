class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.0.tar.gz"
  sha256 "99e3625a6285b3b429af26abb1ec0a4bd0072db144bc4d617a83154d99a5dd1e"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/srt"
    sha256 cellar: :any, mojave: "cabbf459f6d8db791d34625c4fdf3f4a049d259dc03f5ba44b54c658e9af29a3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
