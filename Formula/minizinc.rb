class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.5.tar.gz"
  sha256 "c6c81fa8bdc2d7f8c8d851e5a4b936109f5d996abd8c6f809539f753581c6288"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minizinc"
    rebuild 2
    sha256 cellar: :any, mojave: "31e902f2bcf3c10a5c8128f23856c59f283f2e7c0bc1f10ccc6d1e1157928672"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
