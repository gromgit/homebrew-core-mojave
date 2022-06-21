class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.12.tar.gz"
  sha256 "ba89fb167a5ab6bbdfa6ee3b1a71636e8140fa8471cce8a311697584948e4d06"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libdeflate"
    sha256 cellar: :any, mojave: "d55316765d7d98ce54f1bcf589d555ac7e5c90f3085af1eed4e3812c7323c026"
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
