class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_1/davix-0.8.1.tar.gz"
  sha256 "3f42f4eadaf560ab80984535ffa096d3e88287d631960b2193e84cf29a5fe3a6"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/davix"
    sha256 cellar: :any, mojave: "c86e20238fa585fa4f8f053e6c2c8f3d6cda63895f93ad3d5390d1e6e56b5bae"
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
