class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.8.0.tar.gz"
  sha256 "cd6c4770baccfea385c0c6891a8a80133ba26093209740ca0a3eea348aff1a20"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/croaring"
    sha256 cellar: :any_skip_relocation, mojave: "52f5ad4688b78b8cecf562950af16c52fca4bc575e6449042461fdfc190c182f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
