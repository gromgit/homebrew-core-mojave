class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v1.7.1.tar.gz"
  sha256 "6430e4092653380d9dc4ccb45a1e2dc9259d581f4866dc0759713126056bc1d7"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/google-benchmark"
    sha256 cellar: :any_skip_relocation, mojave: "d8f745652c26592d2cc838f4af4d2a501dd558ba328fca2ab59ae54bd3a0236f"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
