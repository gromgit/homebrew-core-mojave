class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/libwbxml-0.11.8.tar.gz"
  sha256 "a6fe0e55369280c1a7698859a5c2bb37c8615c57a919b574cd8c16458279db66"
  license "LGPL-2.1"
  head "https://github.com/libwbxml/libwbxml.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libwbxml"
    sha256 cellar: :any, mojave: "102e368bd8f6449b9c4e6dca3169900d45821e24849a817248d8c3b9ced6c868"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  uses_from_macos "expat"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_DOCUMENTATION=ON",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end
end
