class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/"
  url "https://github.com/never-lang/never/archive/v2.1.8.tar.gz"
  sha256 "3c03f8632c27456cd6bbcd238525cdfdc41197a26e1a4ff6ac0ef2cf01f4159b"
  license "MIT"
  revision 1
  head "https://github.com/never-lang/never.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/never"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "41a8d8504b2aced615f660e1612a684e4cfc6257081575fd669dd33339273b19"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "never"
      lib.install "libnev.a"
    end
    prefix.install "include"
  end

  test do
    (testpath/"hello.nev").write <<~EOS
      func main() -> int
      {
        prints("Hello World!\\n");
        0
      }
    EOS
    assert_match "Hello World!", shell_output("#{bin}/never -f hello.nev")

    (testpath/"test.c").write <<~EOS
      #include "object.h"
      void test_one()
      {
        object * obj1 = object_new_float(100.0);
        object_delete(obj1);
      }
      int main(int argc, char * argv[])
      {
        test_one();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnev", "-o", "test"
    system "./test"
  end
end
