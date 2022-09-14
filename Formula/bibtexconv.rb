class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.3.tar.gz"
  sha256 "c0ce86b5f1eed75ed77cb5cf7c4f3dcea2a7bab512c4ed43489434a21a7967a4"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bibtexconv"
    sha256 cellar: :any, mojave: "c03bc3e2c054127d4993c7c149f25a7fa7de33ab72799cad02baa45e1c9475e0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
