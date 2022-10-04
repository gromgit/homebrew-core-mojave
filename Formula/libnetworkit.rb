class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/10.0.tar.gz"
  sha256 "77187a96dea59e5ba1f60de7ed63d45672671310f0b844a1361557762c2063f3"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libnetworkit"
    rebuild 1
    sha256 cellar: :any, mojave: "a910c443205e292cf4ae3c6f4ca2c0c97a603fe45c88e5e56def9ba31f4934e7"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      flags = ["-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}"]
      # GCC includes libgomp for OpenMP support and does not need any extra flags to use it.
      if OS.mac?
        flags += [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_prefix}/include'",
          "-DOpenMP_CXX_LIB_NAMES='omp'",
          "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_prefix}/lib/libomp.dylib",
        ]
      end
      system "cmake", ".", *std_cmake_args, *flags, ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <networkit/graph/Graph.hpp>
      int main()
      {
        // Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++14"
    system "./test"
  end
end
