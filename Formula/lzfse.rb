class Lzfse < Formula
  desc "Apple LZFSE compression library and command-line tool"
  homepage "https://github.com/lzfse/lzfse"
  url "https://github.com/lzfse/lzfse/archive/lzfse-1.0.tar.gz"
  sha256 "cf85f373f09e9177c0b21dbfbb427efaedc02d035d2aade65eb58a3cbf9ad267"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lzfse"
    rebuild 1
    sha256 cellar: :any, mojave: "a2bd9eebf6b4339f32352fb538104ba2e36fd74b27cf3c94ae1002c9eaf9e1aa"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    File.binwrite("original", Random.new.bytes(0xFFFF))

    system "#{bin}/lzfse", "-encode", "-i", "original", "-o", "encoded"
    system "#{bin}/lzfse", "-decode", "-i", "encoded", "-o", "decoded"

    assert compare_file("original", "decoded")
  end
end
