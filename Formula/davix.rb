class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_2/davix-0.8.2.tar.gz"
  sha256 "8817a24c23f1309b9de233b9a882455f457c42edc2a649dc70fe2524cf76d94c"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/davix"
    sha256 cellar: :any, mojave: "3fe564846d6be67802c10618fa1311417a3c29cae0a89b307acd9b8870121a7f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
