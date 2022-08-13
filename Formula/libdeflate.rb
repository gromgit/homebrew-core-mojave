class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.13.tar.gz"
  sha256 "0d81f197dc31dc4ef7b6198fde570f4e8653c77f4698fcb2163d820a9607c838"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libdeflate"
    sha256 cellar: :any, mojave: "a24847cfd3e388253bc1b7d10f9a7f3122e2b4c73fb09aeb28ae5af6db285982"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
