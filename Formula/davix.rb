class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_0/davix-0.8.0.tar.gz"
  sha256 "2f108da0408a83fb5b9f0c68150d360ba733e4b3a0fe298d45b0d32d28ab7124"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/davix"
    rebuild 1
    sha256 cellar: :any, mojave: "f9413410088fbe7b47301622010aa7596eede8f3ead7ef3faaa718c3020cf5a8"
  end


  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
