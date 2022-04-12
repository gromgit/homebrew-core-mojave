class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.7.tar.gz"
  sha256 "5aa5490e2bc39c3c03f3636c9bca459cb3f8f365e0280fd0c4759ce3119e5b19"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cbc"
    rebuild 1
    sha256 cellar: :any, mojave: "6640102e8b9b5edc9dff2881d9a49df9dd5e853c30ab10821a0a002ffa7b33d3"
  end

  depends_on "pkg-config" => :build
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  def install
    # Work around - same as clp formula
    # Error 1: "mkdir: #{include}/cbc/coin: File exists."
    mkdir include/"cbc/coin"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--includedir=#{include}/cbc"
    system "make"
    system "make", "install"
    pkgshare.install "Cbc/examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "sudoku.cpp",
                    "-L#{lib}", "-lCbc",
                    "-L#{Formula["cgl"].opt_lib}", "-lCgl",
                    "-L#{Formula["clp"].opt_lib}", "-lClp", "-lOsiClp",
                    "-L#{Formula["coinutils"].opt_lib}", "-lCoinUtils",
                    "-L#{Formula["osi"].opt_lib}", "-lOsi",
                    "-I#{include}/cbc/coin",
                    "-I#{Formula["cgl"].opt_include}/cgl/coin",
                    "-I#{Formula["clp"].opt_include}/clp/coin",
                    "-I#{Formula["coinutils"].opt_include}/coinutils/coin",
                    "-I#{Formula["osi"].opt_include}/osi/coin",
                    "-o", "sudoku"
    assert_match "solution is valid", shell_output("./sudoku")
  end
end
