class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.5.5.tar.gz"
  sha256 "52908e95272d0aa7353e8472defd059364a88729c1c85e41b0ec4b8a4d099f60"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rure"
    rebuild 1
    sha256 cellar: :any, mojave: "199febe05e4710d2edf1967039998369a6005777a7f8296f7173150b2f235fb0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
