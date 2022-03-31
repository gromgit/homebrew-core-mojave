class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"
  license "Zlib"
  revision 5
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/apngasm"
    sha256 cellar: :any, mojave: "514b44c332e3c20741a1a0aa74ad5c0c6d13dd5df0a9ecae7bc3afb91f75fce8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    mkdir "build" do
      ENV.cxx11
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
