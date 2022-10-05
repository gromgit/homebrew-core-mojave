class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  stable do
    url "https://github.com/shibatch/sleef/archive/3.5.1.tar.gz"
    sha256 "415ee9b1bcc5816989d3d4d92afd0cd3f9ee89cbd5a33eb008e69751e40438ab"

    # Fix CMake detection of Apple Silicon (arm64).
    # Remove in the next release.
    patch do
      url "https://github.com/shibatch/sleef/commit/7ce51c447a88e35ad0440a906659920b577984c0.patch?full_index=1"
      sha256 "0056eda409a757602db714bcf9273d525d2421d423f096b0042c85f782ee8af9"
    end

    # Fix build/include/sleef.h:6:2: error: unterminated conditional directive.
    # Remove in the next release.
    patch do
      url "https://github.com/shibatch/sleef/commit/d7f7e84a58243c7ccbbd57d91e282725d302091d.patch?full_index=1"
      sha256 "cf61c4440be028aee934578f7ccf98930bfbec892a7ead1c62dd287dbd658a3c"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sleef"
    rebuild 3
    sha256 cellar: :any, mojave: "d948d4da420e8ef9fba85245ff420be0ee5e97af5faf4d2c902ca9afede6106f"
  end

  depends_on "cmake" => :build

  def install
    # File rename patch doesn't apply on macOS so manually modify.
    # Remove in the next release.
    mv "src/libm/sleeflibm_header.h.org", "src/libm/sleeflibm_header.h.org.in" if OS.mac?

    # Parallel build is only supported with Ninja, but Ninja causes Apple clang crash
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_INLINE_HEADERS=TRUE",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end
