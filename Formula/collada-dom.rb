class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 3
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/collada-dom-2.5.0"
    sha256 cellar: :any, mojave: "80396359bd77cbf3369541a538cf829e42c2f39dee1527f3670030cf9f5c0910"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "pcre"

  uses_from_macos "libxml2"

  def install
    # Remove bundled libraries to avoid fallback
    (buildpath/"dom/external-libs").rmtree

    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end
