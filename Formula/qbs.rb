class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  stable do
    url "https://download.qt.io/official_releases/qbs/1.22.0/qbs-src-1.22.0.tar.gz"
    sha256 "ebfd4b4f115f7ad235477ddf74cc7216dfa66b6166372dc0be454691078f9f3e"

    # Fix Xcode support for 13.3. Remove in the next release.
    patch do
      url "https://code.qt.io/cgit/qbs/qbs.git/patch/?id=d64c7802fef2872aa6a78c06648a0aed45250955"
      sha256 "cccc3fc3a00ddd71e12ad7f89d4e391c476b537719ba904a3afc42e658df4313"
    end
  end

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qbs"
    sha256 cellar: :any, mojave: "301e04b490cf6de55fb1c45c4a2637d4a313567f50696cdcfa34ac1cdf4f47ff"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "cmake", ".", "-DQt5_DIR=#{qt5}/lib/cmake/Qt5", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
