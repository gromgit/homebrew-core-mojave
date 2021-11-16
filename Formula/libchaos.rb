class Libchaos < Formula
  desc "Advanced library for randomization, hashing and statistical analysis"
  homepage "https://github.com/maciejczyzewski/libchaos"
  url "https://github.com/maciejczyzewski/libchaos/releases/download/v1.0/libchaos-1.0.tar.gz"
  sha256 "29940ff014359c965d62f15bc34e5c182a6d8a505dc496c636207675843abd15"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1b5eff28e28622055d915653c66c2448cba0cb207a8b8f243525c2deb1dd246"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b51e7e88ad2f47cdb860d3edbf65a9db6a1a0feeefbb46dae978f3b4311f20f"
    sha256 cellar: :any_skip_relocation, catalina:      "8cd295f6ccf1c6a09ab87bef06331424da21b0b44da8f4440a11f4fccaf1370a"
    sha256 cellar: :any_skip_relocation, mojave:        "3add0509ec493248105ad81354c4ffccef85f37c0cc445db24f115b0b8fb3576"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8d1f167a096fae20de66286d9f33a7b93e03fcfccaecd5b15611e3fcd7c4b09c"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DLIBCHAOS_ENABLE_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <chaos.h>
      #include <iostream>
      #include <string>

      int main(void) {
        std::cout << CHAOS_META_NAME(CHAOS_MACHINE_XORRING64) << std::endl;
        std::string hash = chaos::password<CHAOS_MACHINE_XORRING64, 175, 25, 40>(
            "some secret password", "my private salt");
        std::cout << hash << std::endl;
        if (hash.size() != 40)
          return 1;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lchaos", "-o", "test", "test.cc"
    system "./test"
  end
end
