class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.2.tar.gz"
  sha256 "2dfb911d6b27545de0b98798d967c40430312377e6ade57096d6ec80c720cb61"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quazip"
    rebuild 1
    sha256 cellar: :any, mojave: "d6c03d304f4b5eb918fcaa5e3286630db526d0faf4fdf242e1c924c1cc0d24e3"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt@5"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt@5"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
