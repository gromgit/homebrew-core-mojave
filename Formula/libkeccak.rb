class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.2.tar.gz"
  sha256 "c17df59e038f9f1b0f09aa79944ba572f5c4efcbfe8bc6bc7aae1b40f035abe9"
  license "ISC"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libkeccak"
    rebuild 1
    sha256 cellar: :any, mojave: "4128cc4c40bbd628d3a69749c0808e620de8df5b50ef46c78e6fda00e2dbbfa8"
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
