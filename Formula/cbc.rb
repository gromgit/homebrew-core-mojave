class Cbc < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://github.com/coin-or/Cbc"
  url "https://github.com/coin-or/Cbc/archive/releases/2.10.6.tar.gz"
  sha256 "59d0f45c4c6ce399b723e528d637fb8e409dba7449b91ae27edbb5c0617cc65d"
  # update to EPL-2.0 on next release
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cbc"
    sha256 cellar: :any, mojave: "0e0c22fc96e8596b610954e4427bd93bd3ae715d06644c64a62579b7d6d5d15b"
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
