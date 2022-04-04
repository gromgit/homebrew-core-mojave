class Minisat < Formula
  desc "Minimalistic and high-performance SAT solver"
  homepage "https://github.com/stp/minisat"
  url "https://github.com/stp/minisat/archive/releases/2.2.1.tar.gz"
  sha256 "432985833596653fcd698ab439588471cc0f2437617d0df2bb191a0252ba423d"
  license "MIT"
  head "https://github.com/stp/minisat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minisat"
    rebuild 1
    sha256 cellar: :any, mojave: "b77dfd91ad0a32d41f137fc146ade3eecd8fce5bee9a7a0c75edf8823c93abcc"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSTATIC_BINARIES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cnf").write <<~EOS
      p cnf 5 3
      1 -5 4 0
      -1 5 3 4 0
      -3 -4 0
    EOS

    assert_match "SATISFIABLE", shell_output("#{bin}/minisat test.cnf 2>&1", 10)
  end
end
