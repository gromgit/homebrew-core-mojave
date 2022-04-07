class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.13.2.tar.gz"
  sha256 "20beeb32de7c4eb0af9039b21e18370faf847ac8697ab3045906076afbc4caa5"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qtkeychain"
    rebuild 1
    sha256 cellar: :any, mojave: "f2aa21128d28f8be00b3fb168c3ecc5d98479c953939d787c3a233474bff9620"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
    depends_on "libsecret"
  end

  fails_with gcc: "5"

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
    flags = ["-I#{Formula["qt@5"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qt@5"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qt@5"].opt_lib}", "-lQt5Core",
        "-Wl,-rpath,#{Formula["qt@5"].opt_lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqt5keychain", *flags
    system "./test"
  end
end
