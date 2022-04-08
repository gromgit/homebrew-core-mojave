class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.6.tar.gz"
  sha256 "8258b75a72303b661a238047cb348203d88d9dddf85d480ed885f375916fcab6"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zlib-ng"
    sha256 cellar: :any, mojave: "504855df756a3dec01b4beaed7a1e4ee6002dde4ea5d8efdad2ab83393248a49"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("homebrew-test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~EOS
      #include \"zlib-ng.h\"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    EOS

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!\n"
    (testpath/"foo.txt").write content

    system "./zpipe < foo.txt > foo.txt.z"
    assert_predicate testpath/"foo.txt.z", :exist?
    assert_equal content, shell_output("./zpipe -d < foo.txt.z")
  end
end
