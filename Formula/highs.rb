class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "e849276134eb0e7d876be655ff5fe3aa6ecf1030d605edee760620469f9e97cf"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/highs"
    sha256 cellar: :any, mojave: "8ec6d6c28cb6752debd340b962ffb245f38856e4981a7891952807775a70846d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end
