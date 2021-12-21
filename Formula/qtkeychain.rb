class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.13.2.tar.gz"
  sha256 "20beeb32de7c4eb0af9039b21e18370faf847ac8697ab3045906076afbc4caa5"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qtkeychain"
    sha256 cellar: :any, mojave: "8b651570f0bb9feebb7d20bb022c70d9a4bb5e5359780116ada2853d31fb980a"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt5keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqt5keychain",
                    "-I#{Formula["qt@5"].opt_include}",
                    "-F#{Formula["qt@5"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
