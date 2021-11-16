class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/libwbxml-0.11.7.tar.gz"
  sha256 "35e2cf033066edebc0d96543c0bdde87273359e4f4e59291299d41e103bd6338"
  license "LGPL-2.1"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79c3653734dc5a8fbd8707a17e085f8eb3d93367a51aa62f76da1d9ac5001ef2"
    sha256 cellar: :any, big_sur:       "65a96ce0682ac9e3cec8599ef84c52ce89446c001cb6d3751e3962ae62d3ed82"
    sha256 cellar: :any, catalina:      "4adbd8447466f7d3cbad72d5aff2730a87539dacd0638180cd39a9eaee11e174"
    sha256 cellar: :any, mojave:        "9077d1c9669a92c39590de8280678cbe3d50853e76d69fda6a476ba88d170845"
    sha256 cellar: :any, high_sierra:   "051a666b16d73e92e4910f40559d2bb5681ae4b5028a7f86959ad5f6bdb4e55a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_DOCUMENTATION=ON"
      system "make", "install"
    end
  end
end
