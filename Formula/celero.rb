class Celero < Formula
  desc "C++ Benchmark Authoring Library/Framework"
  homepage "https://github.com/DigitalInBlue/Celero"
  url "https://github.com/DigitalInBlue/Celero/archive/v2.8.3.tar.gz"
  sha256 "b87e3b3c5871b9c88b474340970c7e3fa5431cd327b6bbc399594132f8f99bd6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/celero"
    sha256 cellar: :any, mojave: "bd9c0449813255dc283e39b2be7dbbdccd72882942b69cfcb3beb9fb9d58d8fd"
  end

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -DCELERO_COMPILE_DYNAMIC_LIBRARIES=ON
      -DCELERO_ENABLE_EXPERIMENTS=OFF
      -DCELERO_ENABLE_TESTS=OFF
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <celero/Celero.h>
      #include <chrono>
      #include <thread>

      CELERO_MAIN

      BASELINE(DemoSleep, Baseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(10000));
      }
      BENCHMARK(DemoSleep, HalfBaseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(5000));
      }
      BENCHMARK(DemoSleep, TwiceBaseline, 60, 1) {
        std::this_thread::sleep_for(std::chrono::microseconds(20000));
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lcelero", "-o", "test"
    system "./test"
  end
end
