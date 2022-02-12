class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.tar.gz"
  sha256 "f13331e014d9b0b14c2be7b834c3ca817c171cad16801e58e6f1ec5eb981a2ce"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libkeccak"
    sha256 cellar: :any, mojave: "77ebb8d72c61ff49698fdc22d9e9aac7f0758cd66b9b83f3d9095669148143d3"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
